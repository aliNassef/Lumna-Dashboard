import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actionPadding,
  });
  final String title;
  final bool showBackButton;
  final double? actionPadding;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsetsDirectional.only(end: actionPadding ?? 0),
      leadingWidth: 40,
      leading: showBackButton
          ? BackButton(
              color: context.colors.secondary,
            )
          : const SizedBox.shrink(),
      centerTitle: true,
      title: Text(
        title,
        style: context.typography.bold18.copyWith(
          color: context.colors.secondary,
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 14.r,
          backgroundColor: context.colors.primary,
          child: Icon(
            Icons.person,
            color: context.colors.onPrimary,
            size: 16,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
