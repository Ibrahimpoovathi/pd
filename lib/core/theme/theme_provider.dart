import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/preferences.dart';

/// Controls the app [ThemeMode]. Persisted in SharedPreferences.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final raw = ref.watch(prefsProvider).getString(PrefKeys.themeMode);
    return ThemeMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(prefsProvider).setString(PrefKeys.themeMode, mode.name);
  }
}

/// Tracks which feature modules are enabled.
/// The Muslim (prayer) tracker is OFF by default and opt-in via Settings.
final modulesProvider = NotifierProvider<ModulesNotifier, Map<String, bool>>(
  ModulesNotifier.new,
);

class ModulesNotifier extends Notifier<Map<String, bool>> {
  static const defaults = <String, bool>{
    PrefKeys.modulePrayer: false,
    PrefKeys.moduleWater: true,
    PrefKeys.modulePomodoro: true,
    PrefKeys.moduleScreenTime: true,
  };

  @override
  Map<String, bool> build() {
    final prefs = ref.watch(prefsProvider);
    return {
      for (final entry in defaults.entries)
        entry.key: prefs.getBool(entry.key) ?? entry.value,
    };
  }

  Future<void> setEnabled(String key, bool enabled) async {
    state = {...state, key: enabled};
    await ref.read(prefsProvider).setBool(key, enabled);
  }

  bool isEnabled(String key) => state[key] ?? defaults[key] ?? true;
}
