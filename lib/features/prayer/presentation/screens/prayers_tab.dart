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
                        markable: prayerStarted(
                            DateTime.now(), t?.timeOf(p)),
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
                    ? '$streakDays-day all-ada streak. Only on-time days count — a miss or qada resets it.'
                    : 'Mark all five fard on time to start a streak. A miss or qada resets it.',
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
  final bool markable;

  const _PrayerCard({
    required this.prayer,
    required this.time,
    required this.record,
    required this.markable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayed = record.prayed(prayer);
    final isQada = record.qada(prayer);
    return Opacity(
      opacity: markable ? 1.0 : 0.55,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          // Whole card toggles: big touch target, no precise checkbox aim.
          // Locked until the prayer time starts.
          onTap: () => markable
              ? _setPrayed(ref, !prayed)
              : _lockedHint(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.25,
                      child: Checkbox(
                        value: prayed,
                        onChanged: markable
                            ? (_) => _setPrayed(ref, !prayed)
                            : null,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prayer.label,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          time == null
                              ? '--:--'
                              : DateFormat('h:mm a').format(time!),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (prayed)
                    _AdaQadaBadge(
                      isQada: isQada,
                      onTap: () => _setQada(ref, !isQada),
                    ),
                ],
              ),
              if (prayed)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    children: [
                      _EmojiToggle(
                        emoji: '👥',
                        label: "Jama'at — prayed with congregation",
                        selected: record.jamaat(prayer),
                        onTap: () => _setField(
                            ref, _jamaatCompanion(!record.jamaat(prayer))),
                      ),
                      const SizedBox(width: 4),
                      _EmojiToggle(
                        emoji: '🕌',
                        label: 'In mosque',
                        selected: record.mosque(prayer),
                        onTap: () => _setField(
                            ref, _mosqueCompanion(!record.mosque(prayer))),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  void _lockedHint(BuildContext context) {
    final when = time == null
        ? 'its time starts'
        : DateFormat('h:mm a').format(time!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${prayer.label} can be marked once $when.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _setPrayed(WidgetRef ref, bool value) async {
    // Unmarking clears qada + jama'at/mosque together to keep consistent.
    await savePrayerRecord(
      ref,
      record.id,
      value ? _prayedCompanion(true) : _clearedCompanion(),
    );
  }

  Future<void> _setQada(WidgetRef ref, bool value) async {
    await savePrayerRecord(ref, record.id, _qadaCompanion(value));
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

  PrayerRecordsCompanion _qadaCompanion(bool v) {
    switch (prayer) {
      case PrayerName.fajr:
        return PrayerRecordsCompanion(fajrQada: Value(v));
      case PrayerName.dhuhr:
        return PrayerRecordsCompanion(dhuhrQada: Value(v));
      case PrayerName.asr:
        return PrayerRecordsCompanion(asrQada: Value(v));
      case PrayerName.maghrib:
        return PrayerRecordsCompanion(maghribQada: Value(v));
      case PrayerName.isha:
        return PrayerRecordsCompanion(ishaQada: Value(v));
    }
  }

  PrayerRecordsCompanion _clearedCompanion() {
    switch (prayer) {
      case PrayerName.fajr:
        return const PrayerRecordsCompanion(
          fajr: Value(false),
          fajrJamaat: Value(false),
          fajrMosque: Value(false),
          fajrQada: Value(false),
        );
      case PrayerName.dhuhr:
        return const PrayerRecordsCompanion(
          dhuhr: Value(false),
          dhuhrJamaat: Value(false),
          dhuhrMosque: Value(false),
          dhuhrQada: Value(false),
        );
      case PrayerName.asr:
        return const PrayerRecordsCompanion(
          asr: Value(false),
          asrJamaat: Value(false),
          asrMosque: Value(false),
          asrQada: Value(false),
        );
      case PrayerName.maghrib:
        return const PrayerRecordsCompanion(
          maghrib: Value(false),
          maghribJamaat: Value(false),
          maghribMosque: Value(false),
          maghribQada: Value(false),
        );
      case PrayerName.isha:
        return const PrayerRecordsCompanion(
          isha: Value(false),
          ishaJamaat: Value(false),
          ishaMosque: Value(false),
          ishaQada: Value(false),
        );
    }
  }
}

/// Single ad/qd toggle badge. Defaults to ad when the prayer is marked.
class _AdaQadaBadge extends StatelessWidget {
  final bool isQada;
  final VoidCallback onTap;

  const _AdaQadaBadge({required this.isQada, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = isQada
        ? scheme.tertiary.withValues(alpha: 0.2)
        : scheme.primary.withValues(alpha: 0.2);
    final fg = isQada ? scheme.tertiary : scheme.primary;
    return Tooltip(
      message: isQada
          ? 'Qada: made up after its time — tap for Ada'
          : 'Ada: prayed on time — tap for Qada',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Semantics(
          button: true,
          label: isQada ? 'Qada, made up late' : 'Ada, prayed on time',
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: fg.withValues(alpha: 0.5)),
            ),
            child: Text(
              isQada ? 'qd' : 'ad',
              style: TextStyle(
                color: fg,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Emoji-only toggle (👥 jama'at, 🕌 mosque). Greyed when off.
class _EmojiToggle extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _EmojiToggle({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Semantics(
          button: true,
          label: label,
          child: Opacity(
            opacity: selected ? 1.0 : 0.35,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? scheme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? scheme.primary.withValues(alpha: 0.6)
                      : scheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
