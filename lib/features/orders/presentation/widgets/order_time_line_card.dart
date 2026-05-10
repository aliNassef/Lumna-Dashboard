import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import 'time_line_item.dart';

class OrderTimelineCard extends StatelessWidget {
  const OrderTimelineCard({super.key});

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
          Text('Order Timeline', style: context.typography.bold20),
          const Gap(24),

          TimelineItem(
            title: 'Order Placed',
            subtitle: 'Oct 24, 2023 - 10:45 AM',
            description:
                'Customer successfully placed the order and payment was authorized.',
            icon: Icon(
              Icons.check_circle,
              color: context.colors.primary,
              size: 24,
            ),
          ),

          TimelineItem(
            title: 'Processing',
            subtitle: 'Pending',
            description: 'Order is being prepared in the warehouse.',
            isLast: true,
            icon: Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey[400],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
