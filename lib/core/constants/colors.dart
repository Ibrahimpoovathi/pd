import 'package:flutter/material.dart';

/// GitHub Dark palette used for the dark theme.
abstract final class GithubDark {
  static const background = Color(0xFF0D1117);
  static const surface = Color(0xFF161B22);
  static const surfaceElevated = Color(0xFF21262D);
  static const border = Color(0xFF30363D);
  static const textPrimary = Color(0xFFE6EDF3);
  static const textSecondary = Color(0xFF8B949E);
  static const accentBlue = Color(0xFF58A6FF);
  static const accentGreen = Color(0xFF3FB950);
  static const accentOrange = Color(0xFFD29922);
  static const accentRed = Color(0xFFF85149);
  static const accentPurple = Color(0xFFA371F7);
}

/// Sepia / off-white palette used for the light theme.
/// Warm paper-like background with dark-brown text to reduce eye strain.
abstract final class SepiaLight {
  static const background = Color(0xFFFDF6E3);
  static const surface = Color(0xFFF5EBE0);
  static const surfaceElevated = Color(0xFFEBE3D6);
  static const border = Color(0xFFDCCDB8);
  static const textPrimary = Color(0xFF3C3836);
  static const textSecondary = Color(0xFF6B655D);
  static const accentBlue = Color(0xFF268BD2);
  static const accentGreen = Color(0xFF859900);
  static const accentOrange = Color(0xFFB58900);
  static const accentRed = Color(0xFFDC322F);
  static const accentPurple = Color(0xFF6C71C4);
}

/// Warm Night palette (Stillness-inspired default dark theme).
/// GitHub Dark base with warm ember accent.
abstract final class WarmNight {
  static const background = Color(0xFF0D0B09);
  static const surface = Color(0xFF161210);
  static const surfaceElevated = Color(0xFF221C19);
  static const border = Color(0xFF33291F);
  static const textPrimary = Color(0xFFEDE8E1);
  static const textSecondary = Color(0xFF9A8A7A);
  static const accentBlue = Color(0xFFE07A5F); // Ember
  static const accentGreen = Color(0xFF7A9A6A);
  static const accentOrange = Color(0xFFD2996A);
  static const accentRed = Color(0xFFF08080);
  static const accentPurple = Color(0xFF9A7A9A);
}

/// Cool Night palette (Stillness-inspired).
/// GitHub Dark base with cool indigo accent.
abstract final class CoolNight {
  static const background = Color(0xFF0A0D14);
  static const surface = Color(0xFF12161F);
  static const surfaceElevated = Color(0xFF1C2230);
  static const border = Color(0xFF2A3348);
  static const textPrimary = Color(0xFFE6EAF3);
  static const textSecondary = Color(0xFF8A94A6);
  static const accentBlue = Color(0xFF6A7AB8); // Indigo
  static const accentGreen = Color(0xFF6A9A8A);
  static const accentOrange = Color(0xFFD2A26A);
  static const accentRed = Color(0xFFF08080);
  static const accentPurple = Color(0xFF8A7AB8);
}

/// Pure Dark palette (OLED-friendly, maximum contrast).
abstract final class PureDark {
  static const background = Color(0xFF000000);
  static const surface = Color(0xFF0A0A0A);
  static const surfaceElevated = Color(0xFF1A1A1A);
  static const border = Color(0xFF2A2A2A);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A8A8A);
  static const accentBlue = Color(0xFF58A6FF);
  static const accentGreen = Color(0xFF3FB950);
  static const accentOrange = Color(0xFFD29922);
  static const accentRed = Color(0xFFF85149);
  static const accentPurple = Color(0xFFA371F7);
}
