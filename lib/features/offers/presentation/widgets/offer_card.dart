import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/strings_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/offer_model.dart';
import 'offer_status_badge.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.productName,
    this.onEdit,
    this.onDelete,
  });

  final OfferModel offer;
  final String productName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = offer.isActive ? Colors.green : context.colors.error;
    final statusText = offer.isActive
        ? LocaleKeys.badge_active.tr()
        : LocaleKeys.badge_inactive.tr();

    return Container(
      padding: const EdgeInsets.all(Spacing.extraLarge),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  offer.title,
                  style: context.typography.bold20.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ),
              OfferStatusBadge(text: statusText, color: statusColor),
            ],
          ),
          const Gap(Spacing.medium),
          Text(productName, style: context.typography.medium16),
          const Gap(Spacing.medium),
          Text(
            '${offer.discountPercent.toInt()}% ${LocaleKeys.offer_discount.tr()}'
                .localizeDigits,
            style: context.typography.bold18.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(Spacing.small),
          Text(
            '${LocaleKeys.start_date.tr()}: ${offer.startsAt.monthDayYearText}\n ${LocaleKeys.end_date.tr()}: ${offer.endsAt.monthDayYearText}',
            style: context.typography.regular14.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const Gap(Spacing.large),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit, color: context.colors.primary),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: context.colors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
