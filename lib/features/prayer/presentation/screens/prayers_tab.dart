import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';

/// The five daily prayers with prayed / jama'at / mosque toggles,
/// calculated times, streak banner, and location/method summary.
class PrayersTab extends ConsumerWidget {
  const PrayersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(todayPrayerRecordProvider);
    final times = ref.watch(todayPrayerTimesProvider);
    final streak = ref.watch(prayerStreakProvider);
    final settings = ref.watch(prayerSettingsProvider);

    return record.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
      data: (rec) {
        if (rec == null) {
          return const Center(child: Text('Preparing today…'));
        }
        final streakDays = streak.value ?? 0;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StreakBanner(streakDays: streakDays),
            const SizedBox(height: 8),
            settings.when(
              data: (s) => Text(
                _settingsLine(s),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            times.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => ListTile(
                title: const Text('Could not calculate times'),
                subtitle: Text('$e'),
              ),
              data: (t) {
                return Column(
                  children: [
                    if (t == null)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Set your location in the Settings tab to see prayer times. You can still mark prayers below.',
                          ),
                        ),
                      ),
                    for (final p in PrayerName.values)
                      _PrayerCard(
                        prayer: p,
                        time: t?.timeOf(p),
                        record: rec,
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _settingsLine(PrayerSetting s) {
    final method =
        PrayerMethods.entries[s.calculationMethod] ?? s.calculationMethod;
    final loc = s.locationLabel ??
        (s.latitude == null
            ? 'no location'
            : '${s.latitude!.toStringAsFixed(2)}, ${s.longitude!.toStringAsFixed(2)}');
    return '$method · ${PrayerMadhabs.entries[s.madhab] ?? s.madhab} · $loc';
  }
}

class _StreakBanner extends StatelessWidget {
  final int streakDays;

  const _StreakBanner({required this.streakDays});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primary.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.local_fire_department_outlined,
                color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                streakDays > 0
                    ? '$streakDays-day full-fard streak. Miss a fard and it resets to zero.'
                    : 'Mark all five fard to start a streak. A miss resets it to zero.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerCard extends ConsumerWidget {
  final PrayerName prayer;
  final DateTime? time;
  final PrayerRecord record;

  const _PrayerCard({
    required this.prayer,
    required this.time,
    required this.record,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayed = record.prayed(prayer);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
                value: prayed,
                onChanged: (_) => _setPrayed(ref, !prayed),
              ),
              title: Text(
                prayer.label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                time == null ? '--:--' : DateFormat('h:mm a').format(time!),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (prayed)
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text("Jama'at"),
                      selected: record.jamaat(prayer),
                      onSelected: (v) =>
                          _setField(ref, _jamaatCompanion(v)),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('In mosque'),
                      selected: record.mosque(prayer),
                      onSelected: (v) =>
                          _setField(ref, _mosqueCompanion(v)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _setPrayed(WidgetRef ref, bool value) async {
    // Unmarking clears jama'at/mosque together to keep bonuses consistent.
    await savePrayerRecord(
      ref,
      record.id,
      value ? _prayedCompanion(true) : _clearedCompanion(),
    );
  }

  Future<void> _setField(
      WidgetRef ref, PrayerRecordsCompanion entry) async {
    await savePrayerRecord(ref, record.id, entry);
  }

  PrayerRecordsCompanion _prayedCompanion(bool v) {
    switch (prayer) {
      case PrayerName.fajr:
        return PrayerRecordsCompanion(fajr: Value(v));
      case PrayerName.dhuhr:
        return PrayerRecordsCompanion(dhuhr: Value(v));
      case PrayerName.asr:
        return PrayerRecordsCompanion(asr: Value(v));
      case PrayerName.maghrib:
        return PrayerRecordsCompanion(maghrib: Value(v));
      case PrayerName.isha:
        return PrayerRecordsCompanion(isha: Value(v));
    }
  }

  PrayerRecordsCompanion _jamaatCompanion(bool v) {
    switch (prayer) {
      case PrayerName.fajr:
        return PrayerRecordsCompanion(fajrJamaat: Value(v));
      case PrayerName.dhuhr:
        return PrayerRecordsCompanion(dhuhrJamaat: Value(v));
      case PrayerName.asr:
        return PrayerRecordsCompanion(asrJamaat: Value(v));
      case PrayerName.maghrib:
        return PrayerRecordsCompanion(maghribJamaat: Value(v));
      case PrayerName.isha:
        return PrayerRecordsCompanion(ishaJamaat: Value(v));
    }
  }

  PrayerRecordsCompanion _mosqueCompanion(bool v) {
    switch (prayer) {
      case PrayerName.fajr:
        return PrayerRecordsCompanion(fajrMosque: Value(v));
      case PrayerName.dhuhr:
        return PrayerRecordsCompanion(dhuhrMosque: Value(v));
      case PrayerName.asr:
        return PrayerRecordsCompanion(asrMosque: Value(v));
      case PrayerName.maghrib:
        return PrayerRecordsCompanion(maghribMosque: Value(v));
      case PrayerName.isha:
        return PrayerRecordsCompanion(ishaMosque: Value(v));
    }
  }

  PrayerRecordsCompanion _clearedCompanion() {
    switch (prayer) {
      case PrayerName.fajr:
        return const PrayerRecordsCompanion(
          fajr: Value(false),
          fajrJamaat: Value(false),
          fajrMosque: Value(false),
        );
      case PrayerName.dhuhr:
        return const PrayerRecordsCompanion(
          dhuhr: Value(false),
          dhuhrJamaat: Value(false),
          dhuhrMosque: Value(false),
        );
      case PrayerName.asr:
        return const PrayerRecordsCompanion(
          asr: Value(false),
          asrJamaat: Value(false),
          asrMosque: Value(false),
        );
      case PrayerName.maghrib:
        return const PrayerRecordsCompanion(
          maghrib: Value(false),
          maghribJamaat: Value(false),
          maghribMosque: Value(false),
        );
      case PrayerName.isha:
        return const PrayerRecordsCompanion(
          isha: Value(false),
          ishaJamaat: Value(false),
          ishaMosque: Value(false),
        );
    }
  }
}
