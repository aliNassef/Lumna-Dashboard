import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lumna_admin/features/notification/presentation/controller/get_unreaded_count_cubit/get_un_readed_count_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/navigation/nav_args.dart';
import '../../../../core/navigation/nav_animation_enum.dart';
import '../view/notification_history_view.dart';

class NotificationBellIcon extends StatelessWidget {
  const NotificationBellIcon({super.key});

  void _openHistory(BuildContext context) {
    context.pushNamed(
      NotificationHistoryView.routeName,
      arguments: const NavArgs(animation: NavAnimation.fade),
    );
  }

  @override
  Widget build(BuildContext context) {
    // todo: if marked as readed reduce count. 
    return BlocBuilder<GetUnReadedCountCubit, GetUnReadedCountState>(
    buildWhen: (previous, current) =>  current is GetUnReadedCountLoaded 
    || current is GetUnReadedCountFailure 
    || current is GetUnReadedCountLoading,
      builder: (context, state) {
       return switch (state) {
         GetUnReadedCountLoading() => 
       Skeletonizer(
        enabled: true,
         child: IconButton(
            icon: Badge(
              isLabelVisible: true,
              label: const Text(
                '0',
                style: TextStyle(fontSize: 10),
              ),
              child: Icon(
                Icons.circle_notifications_outlined,
                size: 26.sp,
                color: context.colors.primary,
              ),
            ),
            onPressed: () => _openHistory(context),
          ),
       )  ,
         GetUnReadedCountLoaded() =>IconButton(
          icon: Badge(
            isLabelVisible: true,
            label:   Text(
              state.count.toString(),
              style: const TextStyle(fontSize: 10),
            ),
            child: Icon(
              Icons.circle_notifications_outlined,
              size: 26.sp,
              color: context.colors.primary,
            ),
          ),
          onPressed: () => _openHistory(context),
        ),
           _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
