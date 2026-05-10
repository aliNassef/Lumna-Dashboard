import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class HavingAccountQuestion extends StatelessWidget {
  const HavingAccountQuestion({
    super.key,
    required this.question,
    required this.actionText,
    this.onTap,
  });
  final String question;
  final String actionText;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Text.rich(
          TextSpan(
            text: question,
            style: context.typography.medium16.copyWith(
              color: context.colors.onTertiary,
            ),
            children: [
              TextSpan(
                text: ' ',
                style: context.typography.semiBold14.copyWith(
                  color: context.colors.onTertiary,
                ),
              ),
              TextSpan(
                text: actionText,
                recognizer: TapGestureRecognizer()..onTap = onTap,
                style: context.typography.semiBold16.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
