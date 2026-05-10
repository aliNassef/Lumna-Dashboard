import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_button.dart';

class ProductActionsCard extends StatelessWidget {
  const ProductActionsCard({
    super.key,
    required this.onPublish,
    required this.onSaveAsDraft,
  });
  final void Function() onPublish;
  final void Function() onSaveAsDraft;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary Action using your CustomButton
            CustomButton(
              text: LocaleKeys.product_publish.tr(),
              onPressed: () {
                onPublish();
              },
              backgroundColor: context.colors.primary,
              textColor: context.colors.onPrimary,
              radius: 16,
            ),

            const Gap(Spacing.extraLarge),

            // Secondary Action
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  onSaveAsDraft();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.large,
                  ),
                ),
                child: Text(
                  LocaleKeys.product_save_draft.tr(),
                  style: context.typography.bold18.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
