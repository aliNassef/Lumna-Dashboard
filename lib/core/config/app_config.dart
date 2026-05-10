import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    show MapboxOptions;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../firebase_options.dart';
import '../di/injection_container.dart';
import '../helper/cache_helper.dart';
import '../logging/custom_bloc_observer.dart';
import '../logging/logger.dart';
import '../services/auth/deep_link_service.dart';
import '../services/notification/remote_notification_service.dart';
import '../services/notification/notification_service.dart';

class AppConfig {
  static const String appName = 'LUMINA Admin';
  static const Size appDesign = Size(360, 640);
  static const SystemUiOverlayStyle lightOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const SystemUiOverlayStyle darkOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await Supabase.initialize(
      url: 'https://wwwuzefuhknjtyxcztdk.supabase.co',
      anonKey: 'sb_publishable_AfdvIUW9fbKdENs0rz_qbA_KxH4P9ps',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    await setupLocator();
    await ScreenUtil.ensureScreenSize();
    await CacheHelper.init();
    await injector<NotificationService>().init();
    await injector<RemoteNotificationService>().init();
    MapboxOptions.setAccessToken(
      'pk.eyJ1IjoiYWxpLW5hc3NlZiIsImEiOiJjbW94NndiOTkwMXBuMnNzZHZ0aTVpZHppIn0.-VfAJu3mtd7qDd9GSHRDbg',
    );
    DeepLinkService.instance.init();

    Bloc.observer = CustomBlocObserver();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(lightOverlayStyle);
    Logger.info('App Started ✅');
  }
}
