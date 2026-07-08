enum NotificationType {
  general,
  offer,
  order,
}

extension NotificationHandler on NotificationType {
  String get name {
    return switch (this) {
      NotificationType.general => 'general',
      NotificationType.offer => 'offer',
      NotificationType.order => 'order',
    };
  }
}
