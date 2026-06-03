import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_network_image.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/order_item_model.dart';

class OrderItemTile extends StatelessWidget {
  final OrderItemModel item;

  const OrderItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final lightGrey = const Color(0xFFF1F4F2);

    return Container(
      padding: const EdgeInsets.all(Spacing.large),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          CustomNetworkImage(
            img: item.imageUrl!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            bottomEndRadius: 12,
            bottomStartRadius: 12,
            topEndRadius: 12,
            topStartRadius: 12,
          ),

          const Gap(Spacing.large),
          // Product Details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(item.title, style: context.typography.semiBold16),
                const Gap(Spacing.small),
              ],
            ),
          ),
          // Unit Price and Qty
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${LocaleKeys.qty_label.tr()}${item.quantity}',
                  style: context.typography.regular14.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Gap(Spacing.large),
          // Final Price
          Text('\$${item.totalPrice}', style: context.typography.bold16),
        ],
      ),
    );
  }
}
