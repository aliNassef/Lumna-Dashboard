import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/spacer.dart';
import '../../data/models/offer_model.dart';
import 'offer_card.dart';

class OffersLoadingList extends StatelessWidget {
  const OffersLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.extraLarge),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => Skeletonizer(
          enabled: true,
          child: OfferCard(
            offer: OfferModel(
              productId: 'product',
              title: 'Summer Sale',
              discountPercent: 20,
              startsAt: DateTime.now(),
              endsAt: DateTime.now().add(const Duration(days: 7)),
              isActive: true,
            ),
            productName: 'Product',
          ),
        ),
        separatorBuilder: (context, index) => const Gap(Spacing.large),
        itemCount: 3,
      ),
    );
  }
}
