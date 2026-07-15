import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'admin_app.dart';
import 'core/config/app_config.dart';

void main() async {
  await AppConfig.init();
  await initializeDateFormatting();
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [const Locale('en'), const Locale('ar')],
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const AdminApp(),
    ),
  );
}
