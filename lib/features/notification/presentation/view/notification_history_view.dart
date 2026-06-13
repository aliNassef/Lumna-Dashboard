import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controller/notification_cubit/notification_cubit.dart';
import '../widgets/notification_history_view_body.dart';
 
class NotificationHistoryView extends StatefulWidget {
  const NotificationHistoryView({super.key});
  static const String routeName = 'notification-history';

  @override
  State<NotificationHistoryView> createState() =>
      _NotificationHistoryViewState();
}

class _NotificationHistoryViewState extends State<NotificationHistoryView> {
 
 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<NotificationCubit>()..fetchNotificationHistory(),
      child: Scaffold(
        appBar:  
          CustomAppbar(
                title: LocaleKeys.notifications_title.tr(),
                showBackButton: true,
                actionPadding: 20,
              ),
        body: const NotificationHistoryViewBody(),
      ),
    );
  }
}
