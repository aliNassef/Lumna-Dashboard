import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../data/models/card_stats_model.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';

class StatisticsCard extends StatelessWidget {
  final CardStatsModel stat;
  final Color? badgeColor;
  final Color? badgeTextColor;

  const StatisticsCard({
    super.key,
    required this.stat,
    this.badgeColor,
    this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = !stat.percentage.startsWith('-');
    final resolvedBadgeColor =
        badgeColor ??
        (isPositive ? const Color(0xFFC6F4E5) : const Color(0xFFFDE2E1));
    final resolvedBadgeTextColor =
        badgeTextColor ??
        (isPositive ? context.colors.primary : const Color(0xFFB3261E));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.extraLarge),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  stat.icon,
                  color: context.colors.primary,
                ),
              ),
              // Percentage Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: resolvedBadgeColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  stat.percentage,
                  style: context.typography.medium14.copyWith(
                    color: resolvedBadgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const Gap(Spacing.extraLarge),
          Text(
            stat.title.tr(),
            style: context.typography.medium16.copyWith(
              color: context.colors.primaryContainer,
            ),
          ),
          const Gap(8),
          Text(
            stat.amount,
            style: context.typography.bold24.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
