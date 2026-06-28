import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/notification_model.dart';
import '../controller/notification_cubit/notification_cubit.dart';
import 'notification_list_tile.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({
    super.key,
    required this.notifications,
  });

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.extraLarge),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const Divider(height: 4),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return NotificationListTile(
                notification: n,
                isReaded: n.isRead,
                onTap: () {
                  context.read<NotificationCubit>().markAsRead(n.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
