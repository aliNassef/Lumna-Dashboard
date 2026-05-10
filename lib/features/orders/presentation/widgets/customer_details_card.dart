import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/utils/spacer.dart';
import 'package:lumna_admin/features/orders/data/models/order_details_model.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';

class CustomerDetailCard extends StatelessWidget {
  const CustomerDetailCard({super.key, required this.orderDetailsModel});
  final OrderDetailsModel orderDetailsModel;
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
          // Header: Avatar and Name
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: context.colors.primary.withValues(
                  alpha: 0.2,
                ),
                backgroundImage: orderDetailsModel.customerAvatarUrl == null
                    ? null
                    : NetworkImage(orderDetailsModel.customerAvatarUrl!),
                child: orderDetailsModel.customerAvatarUrl == null
                    ? const Icon(Icons.person_2_outlined)
                    : null,
              ),
              const Gap(Spacing.extraLarge),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderDetailsModel.customerName,
                    style: context.typography.bold20,
                  ),
                  const Gap(Spacing.small),
                ],
              ),
            ],
          ),

          const Gap(24),

          // Contact Information Rows
          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            text: orderDetailsModel.customerEmail!,
          ),

          const Gap(16),

          _buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            text: orderDetailsModel.addressPhone ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[700],
        ),
        const Gap(Spacing.large),
        Text(
          text,
          style: context.typography.medium16.copyWith(
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
