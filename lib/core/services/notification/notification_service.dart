import '../../models/show_notification_model.dart';

/// Defines the contract for local notification operations.
abstract interface class NotificationService {
  /// Initializes local notifications for the current platform.
  Future<void> init();

  /// Requests notification permissions from the current platform.
  Future<bool> requestPermissions();

  /// Shows a local notification using the provided request model.
  Future<void> showNotification(ShowNotificationModel notification);
}
