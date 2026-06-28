import 'package:flutter/material.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../data/models/notification_model.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({
    super.key,
    required this.isReaded,
    required this.onTap,
     required this.notification,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
   final bool isReaded;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: !isReaded ? Colors.transparent : context.colors.primary.withValues(alpha: 0.4),
      child: ListTile(
        leading: Icon(
          notification.isOrderType
              ? Icons.shopping_bag_outlined
              : Icons.notifications_outlined,
          color: isReaded
              ? context.colors.onSurfaceVariant
              : context.colors.primary,
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: isReaded ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.body.isNotEmpty)
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                notification.createdAt.orderDisplayText,
                style: context.typography.regular12.copyWith(
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: isReaded
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: onTap,
       ),
    );
  }
}
