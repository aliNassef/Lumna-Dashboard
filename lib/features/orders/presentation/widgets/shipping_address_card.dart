import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/color_extensions.dart';
import 'package:lumna_admin/core/extensions/mediaquery_size.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key, required this.label, required this.street, required this.city, required this.country,  });
  final String label ;
  final String street;
  final String city ;
  final String country ;
   
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHIPPING ADDRESS',
            style: context.typography.bold14.copyWith(
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),
          const Gap(Spacing.extraLarge),
          Text(label, style: context.typography.medium16),
          const Gap(Spacing.small),
          Text(street, style: context.typography.regular16),
          const Gap(Spacing.small),
          Text(city, style: context.typography.regular16),
          const Gap(Spacing.small),
          Text(country, style: context.typography.regular16),
          
        ],
      ),
    );
  }
}
