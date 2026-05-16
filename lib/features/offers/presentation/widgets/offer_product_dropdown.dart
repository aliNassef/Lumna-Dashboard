import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../products/data/models/product_model.dart';

class OfferProductDropdown extends StatelessWidget {
  const OfferProductDropdown({
    super.key,
    required this.products,
    required this.onChanged,
    this.value,
  });

  final String? value;
  final List<ProductModel> products;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      validator: (value) =>
          value == null ? LocaleKeys.offer_select_product.tr() : null,
      hint: Text(LocaleKeys.offer_select_product.tr()),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colors.onPrimary,
        contentPadding: const EdgeInsets.symmetric(
          vertical: Spacing.extraLarge,
          horizontal: Spacing.large,
        ),
        border: OfferProductDropdownBorder(context: context),
        enabledBorder: OfferProductDropdownBorder(context: context),
        focusedBorder: OfferProductDropdownBorder(context: context),
      ),
      items: products
          .map(
            (product) => DropdownMenuItem<String>(
              value: product.id,
              child: Text(product.name),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class OfferProductDropdownBorder extends OutlineInputBorder {
  OfferProductDropdownBorder({required BuildContext context})
    : super(
        borderRadius: BorderRadius.all(Radius.circular(Shape.large)),
        borderSide: BorderSide(color: context.colors.outline),
      );
}
