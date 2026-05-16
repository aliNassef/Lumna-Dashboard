import 'package:flutter/material.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';

class OfferStatusBadge extends StatelessWidget {
  const OfferStatusBadge({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Text(
        text,
        style: context.typography.bold12.copyWith(color: color),
      ),
    );
  }
}
