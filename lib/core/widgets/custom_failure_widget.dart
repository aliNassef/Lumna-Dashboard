import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../exceptions/failure.dart';
import '../extensions/color_extensions.dart';
import '../extensions/padding_extension.dart';
import '../extensions/typography_extension.dart';
import '../utils/spacer.dart';

class CustomFailureWidget extends StatelessWidget {
  const CustomFailureWidget({super.key, required this.failure});
  final Failure failure;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.error_outline_rounded,
          color: context.colors.error,
        ),
        const Gap(Spacing.extraLarge),
        Expanded(
          child: Text(
            failure.errMessage,
            style: context.typography.medium14.copyWith(
              color: context.colors.error,
            ),
          ),
        ),
      ],
    ).withHorizontalPadding(Spacing.large);
  }
}
