import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lumna_admin/core/extensions/padding_extension.dart';
import 'package:lumna_admin/core/di/injection_container.dart';
import 'package:lumna_admin/core/utils/spacer.dart';
import 'package:lumna_admin/core/widgets/custom_app_bar.dart';

import '../controller/notification_cubit/notification_cubit.dart';
import '../widgets/send_notification_view_body.dart';

class SendNotificationView extends StatelessWidget {
  const SendNotificationView({super.key});
  static const routeName = 'send-notification';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => injector<NotificationCubit>(),
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Send Notification',
          showBackButton: false,
          actionPadding: 20,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: const SendNotificationViewBody().withHorizontalPadding(
              Spacing.extraLarge,
            ),
          ),
        ),
      ),
    );
  }
}
