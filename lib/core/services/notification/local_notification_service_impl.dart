import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../exceptions/error_mapper.dart';
import '../../logging/logger.dart';
import '../../models/show_notification_model.dart';
import 'notification_service.dart';

/// Implements local notifications using `flutter_local_notifications`.
class LocalNotificationServiceImpl implements NotificationService {
  LocalNotificationServiceImpl() : _plugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'lumina_general_channel',
        'General Notifications',
        description: 'General notifications for the Lumina app.',
        importance: Importance.defaultImportance,
      );

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    try {
      await _plugin.initialize(initializationSettings);
      await _createAndroidChannel();
      _initialized = true;
      Logger.info('Local notifications initialized ✅');
    } catch (error, stackTrace) {
      Logger.error(
        'Failed to initialize local notifications: ${error.toMessage()}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      var isGranted = true;

      if (Platform.isAndroid) {
        final androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        isGranted =
            await androidPlugin?.requestNotificationsPermission() ?? false;
      }

      if (Platform.isIOS) {
        final iosPlugin = _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        isGranted =
            await iosPlugin?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            ) ??
            false;
      }

      Logger.info('Notification permission granted: $isGranted');
      return isGranted;
    } catch (error, stackTrace) {
      Logger.error(
        'Failed to request notification permissions: ${error.toMessage()}',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  @override
  Future<void> showNotification(ShowNotificationModel notification) async {
    await init();

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _defaultChannel.id,
        _defaultChannel.name,
        channelDescription: _defaultChannel.description,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    try {
      await _plugin.show(
        notification.id,
        notification.title,
        notification.body,
        notificationDetails,
        payload: notification.payload,
      );
      Logger.info('Notification shown with id: ${notification.id}');
    } catch (error, stackTrace) {
      Logger.error(
        'Failed to show notification: ${error.toMessage()}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<void> _createAndroidChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_defaultChannel);
  }
}
