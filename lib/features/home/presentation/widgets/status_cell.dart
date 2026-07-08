import 'package:flutter/material.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';

class StatusCell extends StatelessWidget {
  const StatusCell({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.medium,
          vertical: Spacing.small,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.typography.medium12.copyWith(color: textColor),
        ),
      ),
    );
  }
}
