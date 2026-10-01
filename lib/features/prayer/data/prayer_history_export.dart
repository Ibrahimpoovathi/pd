import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';

/// One day of prayer history with its recomputed section score.
class HistoryDay {
  final DateTime date;
  final PrayerRecord? record;
  final int points;

  HistoryDay({required this.date, required this.record, required this.points});

  /// Dot status for the month grid.
  HistoryStatus get status {
    final r = record;
    if (r == null) return HistoryStatus.none;
    if (r.allAdaDone) return HistoryStatus.allAda;
    if (r.allFardDone) return HistoryStatus.hasQada;
    if (r.fajr || r.dhuhr || r.asr || r.maghrib || r.isha) {
      return HistoryStatus.partial;
    }
    return HistoryStatus.none;
  }
}

enum HistoryStatus { none, partial, hasQada, allAda }

/// Spreadsheet-style cell codes (plain WinAnsi-safe glyphs only):
/// `v` = ada (drawn as a check via ZapfDingbats), `Q` = qada,
/// `-` = missed, trailing `j`/`m` = jama'at/mosque.
String prayerCell(PrayerRecord? record, PrayerName prayer) {
  if (record == null) return '-';
  if (!record.prayed(prayer)) return '-';
  final marks = StringBuffer(record.qada(prayer) ? 'Q' : 'v');
  if (record.jamaat(prayer)) marks.write('j');
  if (record.mosque(prayer)) marks.write('m');
  return marks.toString();
}

String adhkarCell(PrayerRecord? record) {
  if (record == null) return '-';
  final m = record.adhkarMorning;
  final e = record.adhkarEvening;
  if (m && e) return 'ME';
  if (m) return 'M';
  if (e) return 'E';
  return '-';
}

/// Builds a landscape, spreadsheet-styled PDF of [days] (ascending).
/// ZapfDingbats renders the `v` cells as real check marks; everything else
/// is plain Helvetica so no font embedding is needed.
Future<Uint8List> buildPrayerHistoryPdf({
  required List<HistoryDay> days,
  required DateTime from,
  required DateTime to,
}) async {
  final doc = pw.Document();
  final dateFmt = DateFormat('d MMM yyyy');
  final checkFont = pw.Font.zapfDingbats();
  const headerBg = PdfColor.fromInt(0xFF1F6FEB);
  const altRow = PdfColor.fromInt(0xFFF6F8FA);
  const white = PdfColor.fromInt(0xFFFFFFFF);
  const black = PdfColor.fromInt(0xFF000000);

  pw.Widget cell(String text, {bool header = false, bool shade = false}) {
    return pw.Container(
      color: header ? headerBg : (shade ? altRow : white),
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: _cellText(text, header: header, checkFont: checkFont),
    );
  }

  List<pw.TableRow> monthRows(
      String monthLabel, List<HistoryDay> monthDays, int startShade) {
    final rows = <pw.TableRow>[
      pw.TableRow(
        children: [
          pw.Container(
            color: const PdfColor.fromInt(0xFFDDF4FF),
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 4, vertical: 5),
            child: pw.Text(monthLabel,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          for (var i = 0; i < 11; i++)
            pw.Container(
                color: const PdfColor.fromInt(0xFFDDF4FF), child: pw.Text('')),
        ],
      ),
    ];
    var shade = startShade;
    for (final d in monthDays) {
      final r = d.record;
      rows.add(pw.TableRow(children: [
        cell(dateFmt.format(d.date), shade: shade == 1),
        cell(prayerCell(r, PrayerName.fajr), shade: shade == 1),
        cell(prayerCell(r, PrayerName.dhuhr), shade: shade == 1),
        cell(prayerCell(r, PrayerName.asr), shade: shade == 1),
        cell(prayerCell(r, PrayerName.maghrib), shade: shade == 1),
        cell(prayerCell(r, PrayerName.isha), shade: shade == 1),
        cell(r?.tahajjud == true ? 'v' : '-', shade: shade == 1),
        cell(r?.duha == true ? 'v' : '-', shade: shade == 1),
        cell(r?.quranWaqiah == true ? 'v' : '-', shade: shade == 1),
        cell(r?.quranMulk == true ? 'v' : '-', shade: shade == 1),
        cell(adhkarCell(r), shade: shade == 1),
        cell('${d.points}', shade: shade == 1),
      ]));
      shade = 1 - shade;
    }
    // Month totals.
    final total = monthDays.fold<int>(0, (s, d) => s + d.points);
    final fullDays =
        monthDays.where((d) => d.record?.allAdaDone == true).length;
    rows.add(pw.TableRow(children: [
      cell('Total: $total pts · $fullDays/${monthDays.length} full days',
          shade: false),
      for (var i = 0; i < 11; i++) cell('', shade: false),
    ]));
    return rows;
  }

  // Group by month.
  final byMonth = <String, List<HistoryDay>>{};
  final monthFmt = DateFormat('MMMM yyyy');
  for (final d in days) {
    byMonth.putIfAbsent(monthFmt.format(d.date), () => []).add(d);
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(20),
      header: (ctx) => pw.Column(children: [
        pw.Text('PD — Prayer History',
            style: pw.TextStyle(
                fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.Text(
            '${dateFmt.format(from)} – ${dateFmt.format(to)} · Generated ${dateFmt.format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(
          'Legend: v = Ada (on time) · Q = Qada (made up) · - = missed · '
          'trailing j = jamaat, m = mosque · Adhkar: M morning, E evening',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 8),
      ]),
      build: (ctx) {
        final rows = <pw.TableRow>[
          pw.TableRow(children: [
            for (final h in [
              'Date',
              'Fajr',
              'Dhuhr',
              'Asr',
              'Maghrib',
              'Isha',
              'Tahjd',
              'Duha',
              'Waqiah',
              'Mulk',
              'Adhk',
              'Score'
            ])
              cell(h, header: true),
          ]),
        ];
        var shade = 0;
        for (final entry in byMonth.entries) {
          rows.addAll(monthRows(entry.key, entry.value, shade));
          shade = (shade + entry.value.length) % 2;
        }
        return [
          pw.Table(
            border: pw.TableBorder.all(color: black, width: 0.5),
            columnWidths: {
              0: const pw.FixedColumnWidth(64),
              for (var i = 1; i < 12; i++) i: const pw.FlexColumnWidth(1),
            },
            children: rows,
          ),
        ];
      },
    ),
  );
  return doc.save();
}

/// Renders one cell: leading `v` becomes a ZapfDingbats check mark.
pw.Widget _cellText(String text,
    {required bool header, required pw.Font checkFont}) {
  if (!header && text.startsWith('v')) {
    return pw.RichText(
      text: pw.TextSpan(children: [
        pw.TextSpan(
          text: '4',
          style: pw.TextStyle(font: checkFont, fontSize: 11),
        ),
        pw.TextSpan(text: text.substring(1), style: const pw.TextStyle(fontSize: 9)),
      ]),
    );
  }
  return pw.Text(
    text,
    style: pw.TextStyle(
      fontSize: 9,
      fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: header ? PdfColors.white : PdfColors.black,
    ),
  );
}
