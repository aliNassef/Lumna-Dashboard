import 'package:flutter/material.dart';

import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../utils/shape.dart';
import '../utils/spacer.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.radius,
    this.width,
    this.isDisabled = false,
    this.icon = const SizedBox.shrink(),
  });
  final String text;
  final Function()? onPressed;
  final double? radius;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget icon;
  final double? width;
  final bool isDisabled;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(0),
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.large,
          ),
          backgroundColor:   backgroundColor ?? context.colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? Shape.small),
          ),
        ),
        icon: icon,
        label: Text(
          text,
          style: context.typography.bold18.copyWith(
            color: textColor ?? context.colors.onPrimaryContainer,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
