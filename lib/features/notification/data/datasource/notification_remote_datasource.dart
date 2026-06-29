import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';
import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../models/notification_model.dart';
import '../models/send_notification_request.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> sendNotification(SendNotificationRequest request);
  Future<List<NotificationModel>> fetchNotificationHistory();
  Future<void> markAsRead(String notificationId);
   Future<int> getUnReadedCount() ;
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl({
    required SupabaseClient supabaseClient,
    required Database database,
  }) : _database = database,
       _supabaseClient = supabaseClient;
  final Database _database;
  final SupabaseClient _supabaseClient;

  @override
  Future<void> sendNotification(SendNotificationRequest request) async {
    try {
      await _supabaseClient.functions.invoke(
        'notification_handler',
        body: request.toMap(),
      );
    } on FunctionException catch (e) {
      throw ServerException(
        e.details?.toString() ?? e.reasonPhrase ?? e.toString(),
      );
    } catch (e) {
      throw ServerException(e.toMessage());
    }
  }

  @override
  Future<List<NotificationModel>> fetchNotificationHistory() async {
    final adminId = _supabaseClient.auth.currentUser?.id;
    if (adminId == null) {
      throw const ServerException('No authenticated admin found');
    }

    final notificationsResponse = await _database.get(
      path: Endpoints.notifications,
      orderBy: 'created_at',
      ascending: false,
    );

    final readRows = await _database.get(
      path: Endpoints.notificationAdminReads,
      columns: 'notification_id',
      filterColumn: 'admin_id',
      filterValue: adminId,
    );

    final readNotificationIds = readRows
        .map((row) => row['notification_id'] as String)
        .toSet();

    return notificationsResponse.map((row) {
      return NotificationModel.fromMap(
        row,
      ).copyWith(isRead: readNotificationIds.contains(row['id']));
    }).toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final adminId = _supabaseClient.auth.currentUser?.id;
  
    await _database.upsert(
      path: Endpoints.notificationAdminReads,
      data: {
        'notification_id': notificationId,
        'admin_id': adminId,
        'read_at': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Future<int> getUnReadedCount() async {
      final notifications = await _database.get(
      path: Endpoints.notifications,
    );
        final adminNotifications =    await _database.get(path : Endpoints.notificationAdminReads,filterColumn: 'admin_id' , filterValue: _supabaseClient.auth.currentUser?.id);
        return notifications.length - adminNotifications.length;
    } 
}
