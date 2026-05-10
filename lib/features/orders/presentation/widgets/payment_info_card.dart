import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/color_extensions.dart';
import 'package:lumna_admin/core/extensions/payment_method.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import 'package:lumna_admin/core/utils/shape.dart';
import 'package:lumna_admin/core/utils/spacer.dart';

import '../../../../core/extensions/typography_extension.dart';

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({super.key, required this.paymentMethod});
  final PaymentMethod paymentMethod;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.section_payment_information.tr(),
            style: context.typography.bold14.copyWith(
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
          const Gap(Spacing.extraLarge),
          Container(
            padding: const EdgeInsets.all(Spacing.extraLarge),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(Shape.extraLarge),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.credit_card,
                  color: context.colors.primary,
                  size: 28,
                ),
                const Gap(Spacing.extraLarge),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paymentMethod.value.toUpperCase(),
                      style: context.typography.semiBold16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
