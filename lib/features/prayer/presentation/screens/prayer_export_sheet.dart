import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/prayer/data/prayer_history_export.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';
import 'package:pd/features/scoring/presentation/providers/score_providers.dart';
import 'package:printing/printing.dart';

/// Range picker (30/90/365-day presets + custom) → builds the PDF and
/// opens the system share sheet (save, send, print — no permission needed).
class PrayerExportSheet extends ConsumerStatefulWidget {
  const PrayerExportSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const PrayerExportSheet(),
    );
  }

  @override
  ConsumerState<PrayerExportSheet> createState() =>
      _PrayerExportSheetState();
}

enum _Preset { days30, days90, days365, custom }

class _PrayerExportSheetState extends ConsumerState<PrayerExportSheet> {
  _Preset _preset = _Preset.days30;
  DateTime? _customFrom;
  DateTime? _customTo;
  bool _working = false;

  DateTime get _today => dateOnly(DateTime.now());

  (DateTime, DateTime) _range() {
    switch (_preset) {
      case _Preset.days30:
        return (_today.subtract(const Duration(days: 29)), _today);
      case _Preset.days90:
        return (_today.subtract(const Duration(days: 89)), _today);
      case _Preset.days365:
        return (_today.subtract(const Duration(days: 364)), _today);
      case _Preset.custom:
        final from = _customFrom ?? _today.subtract(const Duration(days: 29));
        var to = _customTo ?? _today;
        if (to.isAfter(_today)) to = _today;
        // Cap custom ranges at 366 days.
        final earliest = to.subtract(const Duration(days: 365));
        return (from.isBefore(earliest) ? earliest : from, to);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy');
    final (from, to) = _range();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export prayer history',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioGroup<_Preset>(
              groupValue: _preset,
              onChanged: (v) => setState(() => _preset = v!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<_Preset>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Last 30 days'),
                    value: _Preset.days30,
                  ),
                  RadioListTile<_Preset>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Last 90 days'),
                    value: _Preset.days90,
                  ),
                  RadioListTile<_Preset>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Last 365 days'),
                    value: _Preset.days365,
                  ),
                  RadioListTile<_Preset>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Custom range'),
                    value: _Preset.custom,
                  ),
                ],
              ),
            ),
            if (_preset == _Preset.custom)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(true),
                      child: Text(_customFrom == null
                          ? 'From'
                          : fmt.format(_customFrom!)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(false),
                      child: Text(_customTo == null
                          ? 'To'
                          : fmt.format(_customTo!)),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${fmt.format(from)} – ${fmt.format(to)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: _working
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share_outlined),
                label: const Text('Generate & share PDF'),
                onPressed: _working ? null : () => _export(from, to),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_customFrom ?? now.subtract(const Duration(days: 29)))
          : (_customTo ?? now),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _customFrom = dateOnly(picked);
          if (_customTo != null && _customTo!.isBefore(_customFrom!)) {
            _customTo = _customFrom;
          }
        } else {
          _customTo = dateOnly(picked);
          if (_customFrom != null && _customFrom!.isAfter(_customTo!)) {
            _customFrom = _customTo;
          }
        }
      });
    }
  }

  Future<void> _export(DateTime from, DateTime to) async {
    setState(() => _working = true);
    try {
      final repo = ref.read(prayerRepositoryProvider);
      final records = await repo.recordsBetween(from, to);
      final byDay = {for (final r in records) dateOnly(r.date): r};
      final scores = ref.read(scoreServiceProvider);
      final days = <HistoryDay>[];
      var cursor = dateOnly(from);
      final end = dateOnly(to);
      while (!cursor.isAfter(end)) {
        days.add(HistoryDay(
          date: cursor,
          record: byDay[cursor],
          points: await scores.prayerScoreOn(cursor),
        ));
        cursor = cursor.add(const Duration(days: 1));
      }
      final bytes = await buildPrayerHistoryPdf(
          days: days, from: from, to: to);
      final fmt = DateFormat('yyyyMMdd');
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'pd-prayer-history-${fmt.format(from)}-${fmt.format(to)}.pdf',
      );
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }
}
