import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';

import '../extensions/color_extensions.dart';
import '../extensions/typography_extension.dart';
import '../navigation/app_navigation.dart';
import '../utils/shape.dart';
import '../utils/spacer.dart';
import 'custom_button.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = context.colors.primary;

    return Dialog(
      // Using Shape.extraLarge (22.0.r) for the dialog corners
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      elevation: 0,
      backgroundColor: context.colors.onPrimary,
      child: Padding(
        // Using Spacing.extraLarge (16.0) for internal padding
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(Spacing.large),
            // Illustrative Icon
            Container(
              padding: const EdgeInsets.all(Spacing.extraLarge),
              decoration: BoxDecoration(
                color: context.colors.onPrimary,
                borderRadius: BorderRadius.circular(Shape.medium),
              ),
              child: Icon(
                Icons.rocket_launch_outlined,
                color: primaryGreen,
                size: 48,
              ),
            ),
            const Gap(Spacing.extraLarge),
            // Text Content
            Text(
              LocaleKeys.coming_soon_title.tr(),
              style: context.typography.bold24.copyWith(color: primaryGreen),
            ),
            const Gap(Spacing.medium),
            Text(
              LocaleKeys.coming_soon_message.tr(),
              textAlign: TextAlign.center,
              style: context.typography.regular14.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const Gap(
              Spacing.extraLarge,
            ),
            // Action Button
            CustomButton(
              text: LocaleKeys.got_it.tr(),
              onPressed: () => context.pop(),
              radius: Shape.large,
            ),
          ],
        ),
      ),
    );
  }
}
