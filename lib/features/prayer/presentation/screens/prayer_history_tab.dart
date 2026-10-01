import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/core/utils/date_helpers.dart';
import 'package:pd/features/prayer/data/prayer_history_export.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';
import 'package:pd/features/prayer/presentation/screens/prayer_export_sheet.dart';

/// Month grid of prayer history (up to 12 months back) with per-day
/// detail and PDF export.
class PrayerHistoryTab extends ConsumerStatefulWidget {
  const PrayerHistoryTab({super.key});

  @override
  ConsumerState<PrayerHistoryTab> createState() => _PrayerHistoryTabState();
}

class _PrayerHistoryTabState extends ConsumerState<PrayerHistoryTab> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _shift(int delta) {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month - 11);
    final candidate = DateTime(_month.year, _month.month + delta);
    if (candidate.isAfter(DateTime(now.year, now.month))) return;
    if (candidate.isBefore(first)) return;
    setState(() => _month = candidate);
  }

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(monthRecordsProvider(_month));
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _shift(-1),
              ),
              Expanded(
                child: Text(
                  DateFormat('MMMM yyyy').format(_month),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _shift(1),
              ),
              IconButton(
                tooltip: 'Export PDF',
                icon: const Icon(Icons.share_outlined),
                onPressed: () => PrayerExportSheet.show(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              _Weekday('M'),
              _Weekday('T'),
              _Weekday('W'),
              _Weekday('T'),
              _Weekday('F'),
              _Weekday('S'),
              _Weekday('S'),
            ],
          ),
        ),
        Expanded(
          child: records.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Could not load: $e')),
            data: (rows) {
              final byDay = {for (final r in rows) dateOnly(r.date): r};
              final firstWeekday = DateTime(_month.year, _month.month, 1)
                  .weekday; // Mon=1
              final daysInMonth =
                  DateTime(_month.year, _month.month + 1, 0).day;
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: (firstWeekday - 1) + daysInMonth,
                itemBuilder: (context, i) {
                  final dayNum = i - (firstWeekday - 1) + 1;
                  if (dayNum < 1) return const SizedBox.shrink();
                  final date =
                      DateTime(_month.year, _month.month, dayNum);
                  final isFuture = date.isAfter(dateOnly(DateTime.now()));
                  final rec = byDay[dateOnly(date)];
                  final status = HistoryDay(
                          date: date, record: rec, points: 0)
                      .status;
                  return _DayCell(
                    day: dayNum,
                    status: status,
                    isFuture: isFuture,
                    isToday: isToday(date),
                    onTap: rec == null
                        ? null
                        : () => _DayDetailSheet.show(context, date, rec),
                  );
                },
              );
            },
          ),
        ),
        const _Legend(),
      ],
    );
  }
}

class _Weekday extends StatelessWidget {
  final String label;
  const _Weekday(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final HistoryStatus status;
  final bool isFuture;
  final bool isToday;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.status,
    required this.isFuture,
    required this.isToday,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dot = switch (status) {
      HistoryStatus.allAda => scheme.primary,
      HistoryStatus.hasQada => Colors.orange,
      HistoryStatus.partial => scheme.error,
      HistoryStatus.none => Colors.transparent,
    };
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isToday ? Border.all(color: scheme.primary) : null,
        ),
        child: Opacity(
          opacity: isFuture ? 0.3 : 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$day'),
              const SizedBox(height: 2),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dot,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Wrap(
        spacing: 12,
        children: [
          _key(scheme.primary, 'All ada'),
          _key(Colors.orange, 'Has qada'),
          _key(scheme.error, 'Missed'),
        ],
      ),
    );
  }

  Widget _key(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class _DayDetailSheet extends ConsumerWidget {
  final DateTime date;
  final PrayerRecord record;

  const _DayDetailSheet({required this.date, required this.record});

  static Future<void> show(
      BuildContext context, DateTime date, PrayerRecord record) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) =>
          _DayDetailSheet(date: date, record: record),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Score recomputed for that date (async, cached by provider family).
    final points = ref.watch(historyDayScoreProvider(date));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, d MMM yyyy').format(date),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _prayerLine(context, PrayerName.fajr, record),
            _prayerLine(context, PrayerName.dhuhr, record),
            _prayerLine(context, PrayerName.asr, record),
            _prayerLine(context, PrayerName.maghrib, record),
            _prayerLine(context, PrayerName.isha, record),
            const SizedBox(height: 8),
            points.when(
              data: (p) => Text('Prayer score: $p',
                  style: Theme.of(context).textTheme.titleMedium),
              loading: () => const Text('Prayer score: …'),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prayerLine(
      BuildContext context, PrayerName prayer, PrayerRecord r) {
    final mark =
        !r.prayed(prayer) ? '–' : (r.qada(prayer) ? 'qd' : 'ad');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text('${prayer.label}: $mark',
          style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
