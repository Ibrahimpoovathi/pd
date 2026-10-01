import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';

/// Tahajjud, Duha, Quran (Waqiah & Mulk highlighted), Adhkar and the
/// Salat / Thahleel / Istighfar checkbox + optional counter rows.
class ExtraIbadahTab extends ConsumerWidget {
  const ExtraIbadahTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(todayPrayerRecordProvider);
    return record.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
      data: (rec) {
        if (rec == null) {
          return const Center(child: Text('Preparing today…'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader(context, 'Night & Forenoon'),
            SwitchListTile(
              title: const Text('Tahajjud'),
              value: rec.tahajjud,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(tahajjud: Value(v)),
              ),
            ),
            SwitchListTile(
              title: const Text('Duha'),
              value: rec.duha,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(duha: Value(v)),
              ),
            ),
            _sectionHeader(context, 'Quran'),
            _HighlightedTile(
              title: 'Surah Al-Waqiah',
              subtitle: 'Nightly recitation',
              value: rec.quranWaqiah,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(quranWaqiah: Value(v)),
              ),
            ),
            _HighlightedTile(
              title: 'Surah Al-Mulk',
              subtitle: 'Nightly recitation',
              value: rec.quranMulk,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(quranMulk: Value(v)),
              ),
            ),
            ListTile(
              title: const Text('Other pages'),
              subtitle: const Text('Any other recitation today'),
              trailing: _Stepper(
                value: rec.quranOtherPages,
                onChanged: (v) => savePrayerRecord(
                  ref,
                  rec.id,
                  PrayerRecordsCompanion(quranOtherPages: Value(v)),
                ),
              ),
            ),
            _sectionHeader(context, 'Adhkar'),
            SwitchListTile(
              title: const Text('Morning adhkar'),
              value: rec.adhkarMorning,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(adhkarMorning: Value(v)),
              ),
            ),
            SwitchListTile(
              title: const Text('Evening adhkar'),
              value: rec.adhkarEvening,
              onChanged: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(adhkarEvening: Value(v)),
              ),
            ),
            _sectionHeader(context, 'Dhikr (tick + optional count)'),
            _DhikrRow(
              label: 'Salat (salawat)',
              done: rec.salatDone,
              count: rec.salatCount,
              onDone: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(salatDone: Value(v)),
              ),
              onCount: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(salatCount: Value(v)),
              ),
            ),
            _DhikrRow(
              label: 'Thahleel',
              done: rec.thahleelDone,
              count: rec.thahleelCount,
              onDone: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(thahleelDone: Value(v)),
              ),
              onCount: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(thahleelCount: Value(v)),
              ),
            ),
            _DhikrRow(
              label: 'Isthighfar',
              done: rec.isthighfarDone,
              count: rec.isthighfarCount,
              onDone: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(isthighfarDone: Value(v)),
              ),
              onCount: (v) => savePrayerRecord(
                ref,
                rec.id,
                PrayerRecordsCompanion(isthighfarCount: Value(v)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _HighlightedTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _HighlightedTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primary.withValues(alpha: 0.1),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _Stepper({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
        ),
        Text('$value', style: Theme.of(context).textTheme.titleMedium),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _DhikrRow extends StatefulWidget {
  final String label;
  final bool done;
  final int count;
  final ValueChanged<bool> onDone;
  final ValueChanged<int> onCount;

  const _DhikrRow({
    required this.label,
    required this.done,
    required this.count,
    required this.onDone,
    required this.onCount,
  });

  @override
  State<_DhikrRow> createState() => _DhikrRowState();
}

class _DhikrRowState extends State<_DhikrRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.count == 0 ? '' : '${widget.count}');
  }

  @override
  void didUpdateWidget(covariant _DhikrRow old) {
    super.didUpdateWidget(old);
    // Keep the field in sync when the record changes elsewhere.
    if (old.count != widget.count &&
        _controller.text != '${widget.count}') {
      _controller.text = widget.count == 0 ? '' : '${widget.count}';
    }
    if (old.done != widget.done) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Whole row toggles; the count field keeps its own taps for typing.
      onTap: () => widget.onDone(!widget.done),
      leading: Transform.scale(
        scale: 1.2,
        child: Checkbox(
          value: widget.done,
          onChanged: (v) => widget.onDone(v ?? false),
        ),
      ),
      title: Text(widget.label),
      trailing: SizedBox(
        width: 110,
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Count',
            hintText: 'optional',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onSubmitted: (raw) {
            final n = int.tryParse(raw) ?? 0;
            widget.onCount(n);
            if (!widget.done) widget.onDone(true);
          },
        ),
      ),
    );
  }
}
