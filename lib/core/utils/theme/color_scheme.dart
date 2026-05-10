import 'package:flutter/material.dart';

import '../app_colors.dart';

final lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppLightColors.primary,
  onPrimary: Colors.white,
  primaryContainer: AppLightColors.primaryContainer,
  onPrimaryContainer: Colors.white,

  secondary: AppLightColors.primaryContainer,
  onSecondary: Colors.white,
  onTertiary: AppLightColors.onTertiary,
  surface: AppLightColors.surface,
  onSurface: AppLightColors.onSurface,

  error: const Color(0xFFBA1A1A),
  onError: Colors.white,

  outline: AppLightColors.outlineVariant,
);
final darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: AppDarkColors.primary,
  onPrimary: Colors.black,
  primaryContainer: AppDarkColors.primaryContainer,
  onPrimaryContainer: Colors.white,

  secondary: AppDarkColors.primaryContainer,
  onSecondary: Colors.white,
  onTertiary: AppDarkColors.onTertiary,
  surface: AppDarkColors.surface,
  onSurface: AppDarkColors.onSurface,

  error: const Color(0xFFFFB4AB),
  onError: Colors.black,

  outline: AppDarkColors.outlineVariant,
);
