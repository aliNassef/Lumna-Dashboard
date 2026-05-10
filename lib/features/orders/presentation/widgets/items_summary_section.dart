import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import 'package:lumna_admin/features/orders/data/models/order_item_model.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';
import 'order_item_tile.dart';

class ItemsSummarySection extends StatelessWidget {
  const ItemsSummarySection({super.key, required this.items});
  final List<OrderItemModel> items;
  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (prev, item) => prev + item.totalPrice);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Items Summary', style: context.typography.bold20),
          const Gap(20),

          // Item List
          ...items.map(
            (item) => Column(
              children: [
                OrderItemTile(
                  item: item,
                ),
                const Gap(Spacing.large),
              ],
            ),
          ),

          const Gap(24),
          const Divider(height: 1),
          const Gap(24),

          _buildSummaryRow(
            context,
            LocaleKeys.total.tr(),
            '\$${total.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.typography.regular16.copyWith(color: Colors.grey[600]),
        ),
        Text(value, style: context.typography.bold16),
      ],
    );
  }
}
