import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/features/account/data/models/account_model.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.account});
  final AccountModel account;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              padding: const EdgeInsets.all(Spacing.small),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.primary, width: 6),
              ),
              child: CircleAvatar(
                radius: 80, // Adjust size as needed
                backgroundImage: NetworkImage(
                  account.avatarUrl ?? AppNetworkImage.dummy,
                ),
                backgroundColor: Colors.grey[200],
              ),
            ),
            // Edit Button Overlay
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(Spacing.medium),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  // Using Shape.medium for the small button's rounded corners
                  borderRadius: BorderRadius.circular(Shape.medium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: context.colors.onPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const Gap(Spacing.extraLarge),
        Text(
          account.fullName,
          style: context.typography.bold24,
        ),
        const Gap(Spacing.small),
        Text(
          account.email,
          style: context.typography.regular16.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }
}
