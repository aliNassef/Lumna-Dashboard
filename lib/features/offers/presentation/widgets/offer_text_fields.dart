import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';
import 'offer_field_label.dart';
import '../../../../core/validator/offer_form_validators.dart';

class OfferTextFields extends StatelessWidget {
  const OfferTextFields({
    super.key,
    required this.title,
    required this.discount,
  });

  final TextEditingController title;
  final TextEditingController discount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OfferFieldLabel(text: LocaleKeys.offer_title.tr()),
        const Gap(Spacing.small),
        CustomTextFormField(
          controller: title,
          hintText: LocaleKeys.offer_title_hint.tr(),
          validator: Validators.fieldIsRequired,
        ),
        const Gap(Spacing.large),
        OfferFieldLabel(text: LocaleKeys.offer_discount_percent.tr()),
        const Gap(Spacing.small),
        CustomTextFormField(
          controller: discount,
          hintText: '20',
          keyboardType: TextInputType.number,
          validator: OfferFormValidators.validatePercent,
          prefixIcon: Icons.percent,
        ),
      ],
    );
  }
}
