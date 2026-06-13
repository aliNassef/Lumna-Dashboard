import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widgets/custom_failure_widget.dart';
import '../../data/models/notification_model.dart';
import '../controller/notification_cubit/notification_cubit.dart';
import 'notification_empty_view.dart';
import 'notification_list_view.dart';

class NotificationHistoryViewBody extends StatelessWidget {
  const NotificationHistoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (previous, current) =>
          current.status.isFetchingHistory ||
          current.status.isSuccessFetchHistory ||
          current.status.isFailureFetchHistory ||
          current.status.isSuccessMarkAsRead ,
      builder: (context, state) {
        return switch (state.status) {
          NotificationStatus.fetchingHistory =>  Skeletonizer(
            enabled: true,
            child: NotificationListView(
              notifications: dummyNotifications,
            ),
          ),
          NotificationStatus.successFetchHistory ||
          NotificationStatus.successMarkAsRead ||
          NotificationStatus.failureMarkAsRead =>
            state.notificationHistory.isEmpty
                ? const NotificationEmptyView()
                : NotificationListView(
                                    notifications: state.notificationHistory,
                                  ),
              
          NotificationStatus.failureFetchHistory => CustomFailureWidget(
            failure: state.failure!,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
