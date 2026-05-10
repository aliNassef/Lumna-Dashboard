import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';

class PricingInventoryCard extends StatelessWidget {
  const PricingInventoryCard({
    super.key,
    required this.price,
    required this.stockQuantity,
    required this.salePrice,
    this.titleColor,
    this.labelColor,
  });
  final TextEditingController price;
  final TextEditingController salePrice;
  final TextEditingController stockQuantity;
  final Color? titleColor;
  final Color? labelColor;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              LocaleKeys.pricing_inventory.tr(),
              style: context.typography.bold24.copyWith(
                color: titleColor ?? context.colors.onSurface,
              ),
            ),
            const Gap(32),

            // Price Field
            _buildFieldLabel(context, LocaleKeys.price.tr()),
            const Gap(Spacing.large),

            CustomTextFormField(
              controller: salePrice,
              hintText: LocaleKeys.hint_price_placeholder.tr(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: Icons.attach_money,
              validator: Validators.fieldIsRequired,
            ),
            const Gap(Spacing.large),

            _buildFieldLabel(context, LocaleKeys.sale_price.tr()),
            const Gap(Spacing.large),

            CustomTextFormField(
              controller: price,
              hintText: LocaleKeys.hint_price_placeholder.tr(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: Icons.attach_money,
              validator: Validators.fieldIsRequired,
            ),
            const Gap(Spacing.large),
            // Stock Quantity Field
            _buildFieldLabel(context, LocaleKeys.stock_quantity.tr()),
            const Gap(Spacing.large),

            CustomTextFormField(
              controller: stockQuantity,
              hintText: LocaleKeys.hint_stock_placeholder.tr(),
              keyboardType: TextInputType.number,
              validator: Validators.fieldIsRequired,
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
        color: labelColor ?? context.colors.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
