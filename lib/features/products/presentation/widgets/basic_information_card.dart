import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_form_field.dart';

class BasicInformationCard extends StatelessWidget {
  const BasicInformationCard({
    super.key,
    required this.name,
    required this.description,
  });
  final TextEditingController name;
  final TextEditingController description;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colors.onPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.basic_information.tr(),
              style: context.typography.bold24.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const Gap(32),

            // Product Name Field
            _buildFieldLabel(context, LocaleKeys.product_name.tr()),
            const Gap(Spacing.large),
            CustomTextFormField(
              controller: name,
              hintText: LocaleKeys.hint_product_name_example.tr(),
              validator: Validators.fieldIsRequired,
            ),

            const Gap(24),

            // Description Field
            _buildFieldLabel(context, LocaleKeys.product_description.tr()),
            const Gap(Spacing.large),

            CustomTextFormField(
              controller: description,
              hintText: LocaleKeys.hint_describe_product.tr(),
              maxLines: 5,
              validator: Validators.descriptionValidator,
            ),
            const Gap(Spacing.medium),
            Text(
              LocaleKeys.field_description_hint.tr(),
              style: context.typography.regular12.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: context.typography.bold16.copyWith(
        color: context.colors.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
