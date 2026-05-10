import 'app_text_style.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../../config/app_config.dart';
import 'color_scheme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: AppLightColors.surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppLightColors.outlineVariant,
      systemOverlayStyle: AppConfig.lightOverlayStyle,
    ),
    extensions: [AppTextStyle.light],
    iconTheme: const IconThemeData(
      color: AppLightColors.onSurface,
    ),
    dividerColor: const Color(0xffebefec),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: AppDarkColors.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      systemOverlayStyle: AppConfig.darkOverlayStyle,
    ),
    iconTheme: IconThemeData(
      color: AppDarkColors.outlineVariant,
    ),
    extensions: [AppTextStyle.dark],
  );
}
