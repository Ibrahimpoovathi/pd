import 'package:flutter/material.dart';
import 'package:pd/core/constants/colors.dart';

/// Builds the [ThemeData] for GitHub Dark and Sepia Light themes.
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
