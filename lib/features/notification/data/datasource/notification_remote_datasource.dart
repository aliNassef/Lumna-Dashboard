import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/exceptions/server_exception.dart';
import '../models/send_notification_request.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> sendNotification(SendNotificationRequest request);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl({required SupabaseClient supabaseClient})
    : _supabaseClient = supabaseClient;

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
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
