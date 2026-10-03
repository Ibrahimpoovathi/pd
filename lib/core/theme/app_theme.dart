import 'package:flutter/material.dart';
import 'package:pd/core/constants/colors.dart';

/// Builds the [ThemeData] for GitHub Dark, Sepia Light,
/// and Stillness-inspired Warm/Cool/Pure night variants.
abstract final class AppTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: GithubDark.accentBlue,
      secondary: GithubDark.accentGreen,
      tertiary: GithubDark.accentPurple,
      surface: GithubDark.surface,
      error: GithubDark.accentRed,
      onPrimary: GithubDark.background,
      onSecondary: GithubDark.background,
      onSurface: GithubDark.textPrimary,
      onError: GithubDark.textPrimary,
      outline: GithubDark.border,
    );
    return _build(scheme, GithubDark.background, GithubDark.surfaceElevated,
        GithubDark.textPrimary, GithubDark.textSecondary, GithubDark.border);
  }

  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: SepiaLight.accentBlue,
      secondary: SepiaLight.accentGreen,
      tertiary: SepiaLight.accentPurple,
      surface: SepiaLight.surface,
      error: SepiaLight.accentRed,
      onPrimary: SepiaLight.background,
      onSecondary: SepiaLight.background,
      onSurface: SepiaLight.textPrimary,
      onError: SepiaLight.background,
      outline: SepiaLight.border,
    );
    return _build(scheme, SepiaLight.background, SepiaLight.surfaceElevated,
        SepiaLight.textPrimary, SepiaLight.textSecondary, SepiaLight.border);
  }

  /// Warm Night: GitHub Dark base with warm ember accent.
  static ThemeData warmNight() {
    final scheme = ColorScheme.dark(
      primary: WarmNight.accentBlue,
      secondary: WarmNight.accentGreen,
      tertiary: WarmNight.accentPurple,
      surface: WarmNight.surface,
      error: WarmNight.accentRed,
      onPrimary: WarmNight.background,
      onSecondary: WarmNight.background,
      onSurface: WarmNight.textPrimary,
      onError: WarmNight.textPrimary,
      outline: WarmNight.border,
    );
    return _build(scheme, WarmNight.background, WarmNight.surfaceElevated,
        WarmNight.textPrimary, WarmNight.textSecondary, WarmNight.border);
  }

  /// Cool Night: GitHub Dark base with cool indigo accent.
  static ThemeData coolNight() {
    final scheme = ColorScheme.dark(
      primary: CoolNight.accentBlue,
      secondary: CoolNight.accentGreen,
      tertiary: CoolNight.accentPurple,
      surface: CoolNight.surface,
      error: CoolNight.accentRed,
      onPrimary: CoolNight.background,
      onSecondary: CoolNight.background,
      onSurface: CoolNight.textPrimary,
      onError: CoolNight.textPrimary,
      outline: CoolNight.border,
    );
    return _build(scheme, CoolNight.background, CoolNight.surfaceElevated,
        CoolNight.textPrimary, CoolNight.textSecondary, CoolNight.border);
  }

  /// Pure Dark: OLED-friendly pure black with maximum contrast.
  static ThemeData pureDark() {
    final scheme = ColorScheme.dark(
      primary: PureDark.accentBlue,
      secondary: PureDark.accentGreen,
      tertiary: PureDark.accentPurple,
      surface: PureDark.surface,
      error: PureDark.accentRed,
      onPrimary: PureDark.background,
      onSecondary: PureDark.background,
      onSurface: PureDark.textPrimary,
      onError: PureDark.textPrimary,
      outline: PureDark.border,
    );
    return _build(scheme, PureDark.background, PureDark.surfaceElevated,
        PureDark.textPrimary, PureDark.textSecondary, PureDark.border);
  }

  static ThemeData _build(
    ColorScheme scheme,
    Color scaffoldBg,
    Color elevated,
    Color textPrimary,
    Color textSecondary,
    Color border,
  ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),
      dividerColor: border,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
      ),
      textTheme: ThemeData(brightness: scheme.brightness).textTheme.apply(
            bodyColor: textPrimary,
            displayColor: textPrimary,
          ),
    );
  }
}
