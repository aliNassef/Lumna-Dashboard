import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../logging/logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger.info('Background message: ${message.notification?.title}');
}

class RemoteNotificationService {
  RemoteNotificationService._();

  static final RemoteNotificationService instance =
      RemoteNotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _supabase = Supabase.instance.client;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final ValueNotifier<List<Map<String, dynamic>>> notifications = ValueNotifier(
    [],
  );

  Future<void> init() async {
    await _requestPermission();
    await _saveFcmToken();
    _listenToFcmEvents();
    _listenToInAppNotifications();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    Logger.info('FCM permission: ${settings.authorizationStatus}');
  }

  Future<void> _saveFcmToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final token = await _fcm.getToken();
    if (token == null) return;

    await _upsertToken(userId, token);
    _fcm.onTokenRefresh.listen((newToken) => _upsertToken(userId, newToken));
  }

  Future<void> _upsertToken(String userId, String token) async {
    try {
      await _supabase.from('user_fcm_tokens').upsert(
        {'user_id': userId, 'token': token},
        onConflict: 'user_id',
      );
      Logger.info('FCM token saved');
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to save FCM token',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _listenToFcmEvents() {
    FirebaseMessaging.onMessage.listen((message) {
      Logger.info('Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Logger.info('Notification tapped from background');
      _handleNotificationTap(message.data);
    });

    _fcm.getInitialMessage().then((message) {
      if (message == null) return;
      Logger.info('App opened from terminated via notification');
      _handleNotificationTap(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  void _listenToInAppNotifications() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .listen((data) {
          notifications.value = data;
        });
  }

  Future<bool> sendToAllUsers({
    required String title,
    required String body,
  }) async {
    try {
      await _supabase.functions.invoke(
        'notification_handler',
        body: {'title': title, 'body': body},
      );
      return true;
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to send notification',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to mark notification as read',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> markAllAsRead() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to mark all notifications as read',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  int get unreadCount =>
      notifications.value.where((n) => n['is_read'] == false).length;

  void _handleNotificationTap(Map<String, dynamic> data) {
    Logger.info('Notification data: $data');
  }

  Future<void> onLogout() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _fcm.deleteToken();
      await _supabase.from('user_fcm_tokens').delete().eq('user_id', userId);
    } catch (e, stackTrace) {
      Logger.error(
        'Failed to clear FCM token',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
