import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'admin_app.dart';
import 'core/config/app_config.dart';

void main() async {
  await AppConfig.init();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [const Locale('en'), const Locale('ar')],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: const AdminApp(),
    ),
  );
}