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
    final colors = context.colors;
    // Unread items are visually emphasized: subtle tinted card, accent border,
    // colored icon badge and an unread dot. Read items are muted and flat.
    final accent = isReaded ? colors.onSurfaceVariant : colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isReaded
                ? Colors.transparent
                : colors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isReaded
                  ? Colors.transparent
                  : colors.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notification.isOrderType
                      ? Icons.shopping_bag_outlined
                      : Icons.notifications_outlined,
                  color: accent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          (isReaded
                                  ? context.typography.medium14
                                  : context.typography.bold14)
                              .copyWith(
                                color: isReaded
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                              ),
                    ),
                    if (notification.body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        notification.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.typography.regular12.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      notification.createdAt.orderDisplayText,
                      style: context.typography.regular10.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isReaded) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
