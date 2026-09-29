import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/prayer/data/prayer_time_calculator.dart';
import 'package:pd/features/prayer/domain/prayer_models.dart';
import 'package:pd/features/prayer/presentation/providers/prayer_providers.dart';

/// Calculation method, madhab, location, manual offsets (with reset),
/// and prayer-time notification toggle.
class PrayerSettingsTab extends ConsumerStatefulWidget {
  const PrayerSettingsTab({super.key});

  @override
  ConsumerState<PrayerSettingsTab> createState() => _PrayerSettingsTabState();
}

class _PrayerSettingsTabState extends ConsumerState<PrayerSettingsTab> {
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _offsetControllers = {
    for (final p in PrayerName.values) p: TextEditingController(),
  };
  bool _fieldsLoaded = false;
  bool _locating = false;

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    for (final c in _offsetControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _loadFields(PrayerSetting s) {
    if (_fieldsLoaded) return;
    _fieldsLoaded = true;
    _latController.text =
        s.latitude == null ? '' : s.latitude!.toStringAsFixed(4);
    _lngController.text =
        s.longitude == null ? '' : s.longitude!.toStringAsFixed(4);
    final offsets =
        PrayerTimeCalculator.parseOffsets(s.manualOffsetsJson);
    for (final p in PrayerName.values) {
      final v = offsets[p.label];
      _offsetControllers[p]!.text = v == null ? '' : '$v';
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(prayerSettingsProvider);
    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Could not load: $e')),
      data: (s) {
        _loadFields(s);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _header(context, 'Calculation'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Method'),
              initialValue: PrayerMethods.entries.containsKey(s.calculationMethod)
                  ? s.calculationMethod
                  : PrayerMethods.defaultKey,
              items: [
                for (final e in PrayerMethods.entries.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => _updateSettings(
                PrayerSettingsCompanion(calculationMethod: Value(v!)),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Madhab (Asr)'),
              initialValue: PrayerMadhabs.entries.containsKey(s.madhab)
                  ? s.madhab
                  : PrayerMadhabs.defaultKey,
              items: [
                for (final e in PrayerMadhabs.entries.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) =>
                  _updateSettings(PrayerSettingsCompanion(madhab: Value(v!))),
            ),
            _header(context, 'Location'),
            if (s.locationLabel != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Saved: ${s.locationLabel}'),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latController,
                    decoration:
                        const InputDecoration(labelText: 'Latitude'),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _lngController,
                    decoration:
                        const InputDecoration(labelText: 'Longitude'),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: _locating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location_outlined),
                    label: const Text('Detect my location'),
                    onPressed: _locating ? null : _detectLocation,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveLocation,
                    child: const Text('Save location'),
                  ),
                ),
              ],
            ),
            _header(context, 'Manual time offsets'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Use manual offsets'),
              subtitle: const Text(
                'Add minutes (+/-) per prayer instead of calculated times.',
              ),
              value: s.useManual,
              onChanged: (v) => _updateSettings(
                PrayerSettingsCompanion(useManual: Value(v)),
              ),
            ),
            for (final p in PrayerName.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: _offsetControllers[p],
                  enabled: s.useManual,
                  decoration: InputDecoration(
                    labelText: '${p.label} offset (minutes)',
                    hintText: 'e.g. 2 or -3',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                  ],
                  onSubmitted: (_) => _saveOffsets(),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saveOffsets,
                    child: const Text('Apply offsets'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => _resetToDefault(context),
                    child: const Text('Reset to app default'),
                  ),
                ),
              ],
            ),
            _header(context, 'Notifications'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Prayer-time alerts'),
              subtitle: const Text(
                'Notify at each calculated prayer time.',
              ),
              value: s.notificationsEnabled,
              onChanged: (v) => _updateSettings(
                PrayerSettingsCompanion(notificationsEnabled: Value(v)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Future<void> _updateSettings(PrayerSettingsCompanion entry) async {
    await ref.read(prayerRepositoryProvider).updateSettings(entry);
    ref.invalidate(todayPrayerTimesProvider);
    final settings =
        await ref.read(prayerRepositoryProvider).getSettings();
    await ref
        .read(prayerNotificationsProvider)
        .reschedule(settings: settings, now: DateTime.now());
  }

  Future<void> _saveLocation() async {
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    if (lat == null || lng == null || lat.abs() > 90 || lng.abs() > 180) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Enter a valid latitude (-90..90) and longitude.')),
        );
      }
      return;
    }
    await _updateSettings(PrayerSettingsCompanion(
      latitude: Value(lat),
      longitude: Value(lng),
      locationLabel:
          Value('${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)}'),
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location saved.')),
      );
    }
  }

  Future<void> _detectLocation() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are off. Enable GPS and retry.';
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw 'Location permission denied. Enter coordinates manually.';
      }
      final pos = await Geolocator.getCurrentPosition();
      _latController.text = pos.latitude.toStringAsFixed(4);
      _lngController.text = pos.longitude.toStringAsFixed(4);
      await _updateSettings(PrayerSettingsCompanion(
        latitude: Value(pos.latitude),
        longitude: Value(pos.longitude),
        locationLabel: const Value('GPS location'),
      ));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location detected and saved.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _saveOffsets() async {
    final offsets = <String, int>{};
    for (final p in PrayerName.values) {
      final raw = _offsetControllers[p]!.text.trim();
      if (raw.isEmpty) continue;
      final v = int.tryParse(raw);
      if (v != null) offsets[p.label] = v;
    }
    await _updateSettings(PrayerSettingsCompanion(
      manualOffsetsJson:
          Value(PrayerTimeCalculator.encodeOffsets(offsets)),
    ));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offsets applied.')),
      );
    }
  }

  Future<void> _resetToDefault(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset to app default?'),
        content: const Text(
          'This clears your manual time offsets and returns to calculated times. '
          'Method, madhab and location are kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(prayerRepositoryProvider).resetManual();
      _fieldsLoaded = false;
      ref.invalidate(prayerSettingsProvider);
      ref.invalidate(todayPrayerTimesProvider);
      final settings =
          await ref.read(prayerRepositoryProvider).getSettings();
      await ref
          .read(prayerNotificationsProvider)
          .reschedule(settings: settings, now: DateTime.now());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Back to calculated times.')),
        );
      }
    }
  }
}
