import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class OfferFieldLabel extends StatelessWidget {
  const OfferFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.typography.bold16.copyWith(
        color: context.colors.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
