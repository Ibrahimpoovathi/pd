import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/database.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_controller.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_models.dart';
import 'package:pd/features/pomodoro/domain/pomodoro_palettes.dart';
import 'package:pd/features/pomodoro/presentation/providers/pomodoro_providers.dart';
import 'package:pd/features/pomodoro/presentation/screens/pomodoro_presets_screen.dart';
import 'package:pd/features/pomodoro/presentation/screens/pomodoro_stats_screen.dart';
import 'package:pd/features/pomodoro/presentation/widgets/ambient_toggle.dart';
import 'package:pd/features/pomodoro/presentation/widgets/controls_row.dart';
import 'package:pd/features/pomodoro/presentation/widgets/duration_presets.dart';
import 'package:pd/features/pomodoro/presentation/widgets/focus_orb.dart';
import 'package:pd/features/pomodoro/presentation/widgets/phase_pills.dart';
import 'package:pd/features/pomodoro/presentation/widgets/session_dots.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Pomodoro timer screen (Stillness-inspired).
///
/// - 60fps FocusOrb with breathe/drift/flash
/// - Tap to reveal time (3.6s), long-press to peek cycle
/// - Session dots, phase pills, duration presets, task/intention inline
/// - Ambient toggle, keep-screen-on footer
class PomodoroTimerScreen extends ConsumerStatefulWidget {
  final PomodoroPreset? initialPreset;

  const PomodoroTimerScreen({super.key, this.initialPreset});

  @override
  ConsumerState<PomodoroTimerScreen> createState() =>
      _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends ConsumerState<PomodoroTimerScreen>
    with SingleTickerProviderStateMixin {
  bool _revealed = false;
  bool _peeking = false;
  int _flashTick = 0;
  Timer? _revealTimer;
  Timer? _peekTimer;

  // 60fps ticker driving live progress + time readout.
  late final Ticker _ticker;
  int _frameTick = 0;

  PomodoroPhase? _lastPhase;
  bool? _lastRunning;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      if (mounted) setState(() => _frameTick++);
    });
    if (widget.initialPreset != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = ref.read(pomodoroControllerProvider);
        controller.updateSettings(
          workMinutes: widget.initialPreset!.workMinutes,
          shortBreakMinutes: widget.initialPreset!.shortBreakMinutes,
          longBreakMinutes: widget.initialPreset!.longBreakMinutes,
          totalCycles: widget.initialPreset!.totalCycles,
        );
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _revealTimer?.cancel();
    _peekTimer?.cancel();
    WakelockPlus.disable();
    // Stop ambient when leaving the timer screen.
    try {
      ref.read(pomodoroAmbientEngineProvider).stop();
    } catch (_) {}
    super.dispose();
  }

  void _syncTicker(PomodoroController controller) {
    final running = controller.currentState.isRunning;
    if (running && !_ticker.isTicking) {
      _ticker.start();
    } else if (!running && _ticker.isTicking) {
      _ticker.stop();
    }
    // Keep-screen-on management.
    if (controller.keepScreenOn) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void _syncReveal(PomodoroPhase phase, bool running) {
    if (_lastPhase != null &&
        (_lastPhase != phase || _lastRunning != running)) {
      // Auto-reveal on phase/status change + flash ring.
      _revealed = true;
      _flashTick++;
      _revealTimer?.cancel();
      _revealTimer = Timer(const Duration(milliseconds: 3600), () {
        if (mounted) setState(() => _revealed = false);
      });
    }
    _lastPhase = phase;
    _lastRunning = running;
  }

  AmbientParams? _lastAmbient;

  /// Starts/stops/updates the PCM ambient engine to match controller params.
  void _syncAmbient(PomodoroController controller) {
    final params = AmbientParams(
      mode: controller.ambientMode,
      volume: controller.ambientVolume,
      rainMix: controller.ambientRainMix,
    );
    if (_lastAmbient != null &&
        _lastAmbient!.mode == params.mode &&
        _lastAmbient!.volume == params.volume &&
        _lastAmbient!.rainMix == params.rainMix) {
      return;
    }
    _lastAmbient = params;
    // Fire-and-forget; engine handles init internally.
    Future(() async {
      try {
        final engine = ref.read(pomodoroAmbientEngineProvider);
        if (params.mode == AmbientMode.off) {
          await engine.stop();
        } else if (engine.isRunning) {
          await engine.updateParams(params);
        } else {
          await engine.start(params);
        }
      } catch (_) {}
    });
  }

  void _onTapOrb() {
    setState(() => _revealed = true);
    _revealTimer?.cancel();
    _revealTimer = Timer(const Duration(milliseconds: 3600), () {
      if (mounted) setState(() => _revealed = false);
    });
  }

  void _onLongPressOrb() {
    setState(() {
      _revealed = false;
      _peeking = true;
    });
    _peekTimer?.cancel();
    _peekTimer = Timer(const Duration(milliseconds: 3200), () {
      if (mounted) setState(() => _peeking = false);
    });
  }

  String _formatMs(int ms) {
    final totalSec = (ms / 1000).floor().clamp(0, 1 << 31);
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(pomodoroControllerProvider);
    final state = controller.currentState;
    _syncTicker(controller);
    _syncReveal(state.phase, state.isRunning);
    _syncAmbient(controller);

    // Live values computed per frame (60fps).
    final liveMs = controller.liveRemainingMs();
    final liveProgress = controller.liveProgress();

    final palette = PomodoroPaletteSets.get(
      state.phase,
      controller.colorJourneys[state.phase],
    );
    // ignore: unused_local_variable (keeps ticker alive)
    final _ = _frameTick;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0B09),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Pomodoro', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            tooltip: 'Presets',
            icon: const Icon(Icons.settings_outlined, size: 20),
            onPressed: () async {
              final preset = await Navigator.push<PomodoroPreset>(
                context,
                MaterialPageRoute(
                    builder: (_) => const PomodoroPresetsScreen()),
              );
              if (preset != null && mounted) {
                controller.updateSettings(
                  workMinutes: preset.workMinutes,
                  shortBreakMinutes: preset.shortBreakMinutes,
                  longBreakMinutes: preset.longBreakMinutes,
                  totalCycles: preset.totalCycles,
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Stats',
            icon: const Icon(Icons.bar_chart_outlined, size: 20),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PomodoroStatsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            if (isLandscape) return _buildLandscape(context, controller, state, liveMs, liveProgress, palette);
            return _buildPortrait(context, controller, state, liveMs, liveProgress, palette);
          },
        ),
      ),
    );
  }

  Widget _buildPortrait(
    BuildContext context,
    PomodoroController controller,
    PomodoroState state,
    int liveMs,
    double liveProgress,
    Palette palette,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SessionDots(
                streak: state.currentCycle - 1,
                total: state.totalCycles,
              ),
              const Row(
                children: [
                  AmbientToggleCompact(),
                  SizedBox(width: 8),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          _phaseLabel(state.phase),
          const SizedBox(height: 12),
          // Orb + time
          _orbWithOverlays(
            context, controller, state, liveMs, liveProgress, palette, 300,
          ),
          Text(
            'tap to peek · hold for the cycle',
            style: TextStyle(
              color: Colors.white.withValues(
                  alpha: (_revealed || _peeking) ? 0 : 0.25),
              fontSize: 9,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 10),
          // Task + intention (focus only)
          if (state.phase == PomodoroPhase.work) ...[
            _TaskBarInline(controller: controller),
            _IntentionInline(controller: controller),
            const SizedBox(height: 10),
          ],
          const PhasePillsRow(),
          const SizedBox(height: 10),
          const DurationPresetsRow(),
          const SizedBox(height: 14),
          const ControlsRow(),
          const SizedBox(height: 24),
          _footer(context, controller, state),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildLandscape(
    BuildContext context,
    PomodoroController controller,
    PomodoroState state,
    int liveMs,
    double liveProgress,
    Palette palette,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _phaseLabel(state.phase),
              const SizedBox(height: 10),
              _orbWithOverlays(
                context, controller, state, liveMs, liveProgress, palette, 220,
              ),
              Text(
                'tap to peek · hold for the cycle',
                style: TextStyle(
                  color: Colors.white.withValues(
                      alpha: (_revealed || _peeking) ? 0 : 0.25),
                  fontSize: 9,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SessionDots(
                      streak: state.currentCycle - 1,
                      total: state.totalCycles,
                    ),
                    const AmbientToggleCompact(),
                  ],
                ),
                const SizedBox(height: 8),
                if (state.phase == PomodoroPhase.work) ...[
                  _TaskBarInline(controller: controller),
                  _IntentionInline(controller: controller),
                  const SizedBox(height: 10),
                ],
                const PhasePillsRow(),
                const SizedBox(height: 10),
                const DurationPresetsRow(),
                const SizedBox(height: 14),
                const ControlsRow(),
                const SizedBox(height: 14),
                _footer(context, controller, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _orbWithOverlays(
    BuildContext context,
    PomodoroController controller,
    PomodoroState state,
    int liveMs,
    double liveProgress,
    Palette palette,
    double orbSize,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FocusOrb(
          progress: liveProgress,
          phase: state.phase,
          isRunning: state.isRunning,
          palette: palette,
          flashTick: _flashTick,
          size: orbSize,
          onTap: _onTapOrb,
          onLongPress: _onLongPressOrb,
        ),
        AnimatedOpacity(
          opacity: _revealed ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _formatMs(liveMs),
                style: const TextStyle(
                  color: Color(0xFFEDE8E1),
                  fontSize: 32,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        if (_peeking)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x33000000),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Session ${state.currentCycle} of ${state.totalCycles}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'UP NEXT: ${state.phase == PomodoroPhase.work ? 'break' : 'focus'}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 9,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _phaseLabel(PomodoroPhase phase) {
    final label = switch (phase) {
      PomodoroPhase.work => 'Focus',
      PomodoroPhase.shortBreak => 'Short break',
      PomodoroPhase.longBreak => 'Long break',
      PomodoroPhase.paused => 'Paused',
      PomodoroPhase.completed => 'Session Complete',
    };
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.85),
        fontSize: 13,
        letterSpacing: 2.8,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _footer(
      BuildContext context, PomodoroController controller, PomodoroState state) {
    final wakeLabel = !controller.keepScreenOnEnabled
        ? '○ screen sleep allowed'
        : (controller.keepScreenOn ? '● screen held awake' : '○ idle');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => controller.updateKeepScreenOnEnabled(
              !controller.keepScreenOnEnabled),
          child: Text(
            wakeLabel,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              letterSpacing: 0.6,
            ),
          ),
        ),
        Text(
          'Cycle ${state.currentCycle} of ${state.totalCycles}',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 10,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

/// Inline task bar (Focus phase). Links to To-Do module by ID.
///
/// Tap opens a bottom sheet listing incomplete, non-trashed To-Dos
/// (due today/tomorrow first), plus a custom-label field.
class _TaskBarInline extends ConsumerStatefulWidget {
  final PomodoroController controller;
  const _TaskBarInline({required this.controller});

  @override
  ConsumerState<_TaskBarInline> createState() => _TaskBarInlineState();
}

class _TaskBarInlineState extends ConsumerState<_TaskBarInline> {
  @override
  Widget build(BuildContext context) {
    final display = widget.controller.currentTaskLabel;
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withValues(alpha: 0.04),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                display ?? 'What are you focusing on?',
                style: TextStyle(
                  color: display != null
                      ? Colors.white.withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (display != null)
              GestureDetector(
                onTap: () => setState(
                    () => widget.controller.clearCurrentTask()),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('✕',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5))),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final result = await showModalBottomSheet<_PickedTask>(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _TodoPickerSheet(),
    );
    if (result != null && mounted) {
      setState(() {
        widget.controller.setCurrentTask(id: result.id, label: result.label);
      });
    }
  }
}

class _PickedTask {
  final String? id; // To-Do row id as string, or null for custom label
  final String label;
  const _PickedTask({this.id, required this.label});
}

/// Bottom sheet listing incomplete To-Dos + custom label field.
class _TodoPickerSheet extends ConsumerStatefulWidget {
  const _TodoPickerSheet();

  @override
  ConsumerState<_TodoPickerSheet> createState() => _TodoPickerSheetState();
}

class _TodoPickerSheetState extends ConsumerState<_TodoPickerSheet> {
  final _draft = TextEditingController();

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(pomodoroTodoPickerProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Pick a focus task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _draft,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Or type a custom label…',
                      hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.06),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _pickCustom(context),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _pickCustom(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: const Text('✓',
                        style: TextStyle(color: Color(0xFFE07A5F))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            todosAsync.when(
              loading: () => const Center(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator())),
              error: (e, _) => Text('Error: $e',
                  style: const TextStyle(color: Colors.white70)),
              data: (todos) {
                if (todos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('No open tasks — type a label above.',
                        style: TextStyle(color: Colors.white54)),
                  );
                }
                return Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todos.length.clamp(0, 8),
                    itemBuilder: (ctx, i) {
                      final t = todos[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.checklist_outlined,
                            color: Colors.white54, size: 20),
                        title: Text(t.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        subtitle: t.dueDate == null
                            ? null
                            : Text(
                                'Due ${_formatDue(t.dueDate!)}',
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 11),
                              ),
                        onTap: () => Navigator.pop(
                            context,
                            _PickedTask(
                                id: t.id.toString(), label: t.title)),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickCustom(BuildContext context) {
    final label = _draft.text.trim();
    if (label.isEmpty) return;
    Navigator.pop(context, _PickedTask(label: label));
  }

  String _formatDue(DateTime d) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dd = DateTime(d.year, d.month, d.day);
    if (dd == today) return 'today';
    if (dd == today.add(const Duration(days: 1))) return 'tomorrow';
    return '${d.day}/${d.month}';
  }
}

/// Inline intention input with quick suggestions.
class _IntentionInline extends StatefulWidget {
  final PomodoroController controller;
  const _IntentionInline({required this.controller});

  @override
  State<_IntentionInline> createState() => _IntentionInlineState();
}

class _IntentionInlineState extends State<_IntentionInline> {
  bool _editing = false;
  late TextEditingController _draft;

  static const _suggestions = [
    'clarity',
    'calm',
    'depth',
    'momentum',
    'presence',
    'finish'
  ];

  @override
  void initState() {
    super.initState();
    _draft = TextEditingController(
        text: widget.controller.currentIntention ?? '');
  }

  @override
  void dispose() {
    _draft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.controller.currentIntention;
    if (current == null && !_editing) {
      return GestureDetector(
        onTap: () => setState(() => _editing = true),
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'why this focus? tap to set',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35), fontSize: 12),
          ),
        ),
      );
    }
    if (!_editing) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Intention: $current',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12)),
            GestureDetector(
              onTap: () => setState(() => _editing = true),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text('✎',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4))),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _draft,
                autofocus: true,
                maxLength: 24,
                maxLines: 1,
                style:
                    const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'clarity…',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  counterText: '',
                ),
                onSubmitted: (_) => _save(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _save,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
                child: const Text('✓',
                    style: TextStyle(color: Color(0xFFE07A5F))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          children: [
            for (final w in _suggestions)
              GestureDetector(
                onTap: () {
                  widget.controller.setIntention(w);
                  setState(() => _editing = false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  child: Text(w,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _save() {
    widget.controller.setIntention(_draft.text);
    setState(() => _editing = false);
  }
}
