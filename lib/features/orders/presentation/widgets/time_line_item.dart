import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/spacer.dart';

import '../../../../core/extensions/typography_extension.dart';

class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Widget icon;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Performance-friendly vertical line
        if (!isLast)
          Positioned(
            left: 11.5,
            top: 24,
            bottom: 0,
            child: Container(
              width: 1,
              color: Colors.grey[300],
            ),
          ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            SizedBox(
              width: 24,
              child: Center(child: icon),
            ),
            const Gap(Spacing.extraLarge),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.typography.semiBold16),
                  const Gap(Spacing.small),
                  Text(
                    subtitle,
                    style: context.typography.regular12.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Gap(Spacing.medium),
                  Text(
                    description,
                    style: context.typography.regular14.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  // Bottom padding provides the height for the Stack
                  isLast ? const Gap(0) : const Gap(32),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
