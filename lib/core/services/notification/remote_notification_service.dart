import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../logging/logger.dart';

// ── Background message handler (must be top-level) ───────────────────────────
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.notification?.title}');
}

class RemoteNotificationService {
  RemoteNotificationService._();
  static final RemoteNotificationService instance =
      RemoteNotificationService._();

  final _fcm = FirebaseMessaging.instance;
  final _supabase = Supabase.instance.client;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  // In-memory notification list (or use a state management solution)
  final ValueNotifier<List<Map<String, dynamic>>> notifications = ValueNotifier(
    [],
  );

  // ── Initialize everything ─────────────────────────────────────────────────
  Future<void> init() async {
    await _requestPermission();
    await _saveFcmToken();
    _listenToFcmEvents();
    _listenToInAppNotifications();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // ── Request permission ────────────────────────────────────────────────────
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    Logger.info('FCM permission: ${settings.authorizationStatus}');
  }

  // ── Save FCM token to Supabase ────────────────────────────────────────────
  Future<void> _saveFcmToken() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final token = await _fcm.getToken();
    if (token == null) return;

    await _upsertToken(userId, token);

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) => _upsertToken(userId, newToken));
  }

  Future<void> _upsertToken(String userId, String token) async {
    try {
      await _supabase.from('user_fcm_tokens').upsert(
        {'user_id': userId, 'token': token},
        onConflict: 'user_id',
      );
      Logger.info('FCM token saved');
    } catch (e) {
      Logger.error('Failed to save FCM token: $e');
    }
  }

  // ── Listen to FCM events ──────────────────────────────────────────────────
  void _listenToFcmEvents() {
    // App in foreground
    FirebaseMessaging.onMessage.listen((message) {
      Logger.info('Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // App in background → user tapped notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Logger.info('Notification tapped from background');
      _handleNotificationTap(message.data);
    });

    // App was terminated → user tapped notification
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        Logger.info('App opened from terminated via notification');
        _handleNotificationTap(message.data);
      }
    });
  }

  // ── Show local notification (foreground) ─────────────────────────────────
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

  // ── Listen to in-app notifications from Supabase ──────────────────────────
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

  // ── Send notification to all users (calls Edge Function) ──────────────────
  Future<bool> sendToAllUsers({
    required String title,
    required String body,
  }) async {
    try {
      await _supabase.functions.invoke(
        'send-notification',
        body: {'title': title, 'body': body},
      );
      return true;
    } catch (e) {
      debugPrint('Failed to send notification: $e');
      return false;
    }
  }

  // ── Mark notification as read ─────────────────────────────────────────────
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      debugPrint('Failed to mark as read: $e');
    }
  }

  // ── Mark all notifications as read ───────────────────────────────────────
  Future<void> markAllAsRead() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('user_id', userId)
          .eq('is_read', false);
    } catch (e) {
      debugPrint('Failed to mark all as read: $e');
    }
  }

  // ── Unread count ──────────────────────────────────────────────────────────
  int get unreadCount =>
      notifications.value.where((n) => n['is_read'] == false).length;

  // ── Handle notification tap ───────────────────────────────────────────────
  // ignore: unused_element
  void _onNotificationTap(NotificationResponse response) {
    Logger.info('Local notification tapped: ${response.payload}');
    // Navigate based on payload if needed
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    debugPrint('Notification data: $data');
    // Example: navigate to a specific screen based on data
    // NavigationService.navigateTo(data['route']);
  }

  // ── Delete FCM token on logout ────────────────────────────────────────────
  Future<void> onLogout() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _fcm.deleteToken();
      await _supabase.from('user_fcm_tokens').delete().eq('user_id', userId);
    } catch (e) {
      debugPrint('Failed to clear FCM token: $e');
    }
  }
}
