import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/config/app_config.dart';
import 'core/logging/navigation_observer.dart';
import 'core/navigation/app_routes.dart';
import 'core/navigation/navigator_key.dart';
import 'core/utils/theme/app_theme.dart';
import 'features/layout/presentation/views/layout_view.dart' show LayoutView;

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConfig.appDesign,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: AppConfig.appName,
          navigatorKey: navigatorKey,
          darkTheme: AppTheme.darkTheme,
          navigatorObservers: [AppNavigationObserver()],
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          initialRoute: LayoutView.routeName,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
