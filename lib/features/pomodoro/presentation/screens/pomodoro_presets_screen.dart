import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';

/// Screen to select or create Pomodoro presets.
class PomodoroPresetsScreen extends ConsumerWidget {
  const PomodoroPresetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = ref.watch(pomodoroPresetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Presets')),
      body: presets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (presets) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...presets.map((p) => _PresetTile(preset: p, ref: ref)),
              const SizedBox(height: 16),
              FilledButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create Custom Preset'),
                onPressed: () => _showCustomDialog(context, ref),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCustomDialog(BuildContext context, WidgetRef ref, {PomodoroPreset? preset}) {
    final workCtrl = TextEditingController(text: preset?.workMinutes.toString() ?? '25');
    final shortCtrl = TextEditingController(text: preset?.shortBreakMinutes.toString() ?? '5');
    final longCtrl = TextEditingController(text: preset?.longBreakMinutes.toString() ?? '15');
    final cyclesCtrl = TextEditingController(text: preset?.totalCycles.toString() ?? '4');
    final nameCtrl = TextEditingController(text: preset?.name ?? 'Custom');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(preset == null ? 'Create Custom Preset' : 'Edit Preset'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: workCtrl,
                decoration: const InputDecoration(labelText: 'Work (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: shortCtrl,
                decoration: const InputDecoration(labelText: 'Short Break (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longCtrl,
                decoration: const InputDecoration(labelText: 'Long Break (minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: cyclesCtrl,
                decoration: const InputDecoration(labelText: 'Cycles'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final work = int.tryParse(workCtrl.text) ?? 25;
              final short = int.tryParse(shortCtrl.text) ?? 5;
              final long = int.tryParse(longCtrl.text) ?? 15;
              final cycles = int.tryParse(cyclesCtrl.text) ?? 4;
              
              // Input validation
              if (work <= 0 || short <= 0 || long <= 0 || cycles <= 0) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All values must be positive')),
                  );
                }
                return;
              }
              if (nameCtrl.text.trim().isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty')),
                  );
                }
                return;
              }

              final repo = ref.read(pomodoroRepositoryProvider);
              if (preset == null) {
                await repo.createPreset(
                  name: nameCtrl.text.trim(),
                  workMinutes: work,
                  shortBreakMinutes: short,
                  longBreakMinutes: long,
                  totalCycles: cycles,
                  isCustom: true,
                );
              } else {
                await repo.updatePreset(
                  id: preset.id,
                  name: nameCtrl.text.trim(),
                  workMinutes: work,
                  shortBreakMinutes: short,
                  longBreakMinutes: long,
                  totalCycles: cycles,
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(preset == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }
}

class _PresetTile extends ConsumerWidget {
  final PomodoroPreset preset;
  final WidgetRef ref;

  const _PresetTile({required this.preset, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(preset.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${preset.workMinutes}/${preset.shortBreakMinutes}/${preset.longBreakMinutes} × ${preset.totalCycles}',
        ),
        trailing: preset.isCustom
            ? PopupMenuButton(
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) async {
                  final repo = ref.read(pomodoroRepositoryProvider);
                  if (value == 'delete') {
                    await repo.deletePreset(preset.id);
                  } else if (value == 'edit') {
                    _showEditDialog(context, ref);
                  }
                },
              )
            : null,
        onTap: () {
          Navigator.pop(context, preset);
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final presetsScreen = PomodoroPresetsScreen(key: UniqueKey());
    presetsScreen._showCustomDialog(context, ref, preset: preset);
  }
}
