import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_app_bar.dart';

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
        appBar: CustomAppbar(
          title: LocaleKeys.send_notification_page_title.tr(),
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
