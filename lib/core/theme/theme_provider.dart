import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pd/core/storage/preferences.dart';
import 'package:pd/core/theme/app_theme.dart';

/// App theme variants: GitHub Dark + Sepia Light.
/// Stored values `warmNight`/`coolNight`/`pureDark` from the earlier
/// 4-variant scheme map to `dark` for backward compatibility.
enum AppThemeVariant { dark, sepiaLight }

/// Controls the app theme variant. Persisted in SharedPreferences.
final appThemeVariantProvider =
    NotifierProvider<AppThemeVariantNotifier, AppThemeVariant>(
  AppThemeVariantNotifier.new,
);

class AppThemeVariantNotifier extends Notifier<AppThemeVariant> {
  @override
  AppThemeVariant build() {
    final raw = ref.watch(prefsProvider).getString('app_theme_variant');
    return switch (raw) {
      'sepiaLight' => AppThemeVariant.sepiaLight,
      'dark' => AppThemeVariant.dark,
      // Backward compat: all 3 old dark variants become GitHub Dark.
      'warmNight' || 'coolNight' || 'pureDark' => AppThemeVariant.dark,
      _ => AppThemeVariant.dark,
    };
  }

  Future<void> setVariant(AppThemeVariant variant) async {
    state = variant;
    await ref.read(prefsProvider).setString('app_theme_variant', variant.name);
  }
}

/// Resolves the [ThemeData] for the current variant.
ThemeData appThemeFor(AppThemeVariant variant) {
  switch (variant) {
    case AppThemeVariant.dark:
      return AppTheme.dark();
    case AppThemeVariant.sepiaLight:
      return AppTheme.light();
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
