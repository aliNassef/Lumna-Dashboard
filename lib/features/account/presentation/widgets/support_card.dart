import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import 'preference_tile.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Spacing.medium,
            bottom: Spacing.large,
          ),
          child: Text(
            LocaleKeys.section_support.tr(),
            style: context.typography.bold14.copyWith(
              color: context.colors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Spacing.extraLarge),
          decoration: BoxDecoration(
            color: context.colors.onPrimary,
            borderRadius: BorderRadius.circular(Shape.extraLarge),
          ),
          child: Column(
            children: [
              PreferenceTile(
                icon: Icons.help_outline,

                title: LocaleKeys.help_center.tr(),
                onTap: () {},
              ),
              const Gap(Spacing.extraLarge),
              PreferenceTile(
                icon: Icons.outlined_flag,
                title: LocaleKeys.report_an_issue.tr(),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
