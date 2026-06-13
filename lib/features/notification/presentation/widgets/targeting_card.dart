import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import 'targeting_section.dart';

class TargetingCard extends StatelessWidget {
  const TargetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.extraLarge),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Icon(Icons.group_outlined, color: context.colors.primary),
              const Gap(Spacing.medium),
              Text(
                LocaleKeys.section_targeting.tr(),
                style: context.typography.bold24.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          const Gap(Spacing.extraLarge),

          // Label
          Text(
            LocaleKeys.label_target_audience.tr(),
            style: context.typography.bold12.copyWith(
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
          const Gap(Spacing.medium),

          // Dropdown Field
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.extraLarge,
              vertical: Spacing.medium,
            ),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(Shape.medium),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(LocaleKeys.all_users.tr(), style: context.typography.regular16),
                // const Icon(Icons.expand_more, color: Colors.grey),
              ],
            ),
          ),
          const Gap(Spacing.extraLarge),

          // Selection Tiles
          const TargetingSection(),
          const Gap(Spacing.medium),
          Text(
            LocaleKeys.broadcast_all_users_info.tr(),
            style: context.typography.regular12.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
