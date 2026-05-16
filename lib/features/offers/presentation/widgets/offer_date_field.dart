import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/validator/validators.dart';
import '../../../../core/widgets/custom_form_field.dart';
import 'offer_field_label.dart';
import '../../../../core/validator/offer_form_validators.dart';

class OfferDateField extends StatelessWidget {
  const OfferDateField({
    super.key,
    required this.controller,
    required this.onTap,
    this.startsAt,
    this.endsAt,
    this.isEndDate = false,
  });

  final TextEditingController controller;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isEndDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = isEndDate
        ? LocaleKeys.offer_end_date.tr()
        : LocaleKeys.offer_start_date.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OfferFieldLabel(text: label),
        const Gap(Spacing.small),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: CustomTextFormField(
              controller: controller,
              hintText: label,
              validator: isEndDate ? validateEndDate : Validators.fieldIsRequired,
              prefixIcon: Icons.calendar_today_outlined,
            ),
          ),
        ),
      ],
    );
  }

  String? validateEndDate(String? value) {
    return OfferFormValidators.validateEndDate(
      value: value,
      startsAt: startsAt,
      endsAt: endsAt,
    );
  }
}
