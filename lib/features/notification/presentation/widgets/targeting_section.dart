import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/extensions/app_dialog_extension.dart';
import 'package:lumna_admin/core/extensions/color_extensions.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class TargetingSection extends StatelessWidget {
  const TargetingSection({super.key});

  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SelectionTile(
          title: LocaleKeys.notification_type_push.tr(),
          subtitle: LocaleKeys.notification_type_mobile.tr(),
          isSelected: 0 == _currentIndex,
          primaryColor: context.colors.primary,
          onTap: () {},
        ),
        const Gap(Spacing.medium),
        _SelectionTile(
          title: LocaleKeys.notification_type_email.tr(),
          subtitle: LocaleKeys.notification_type_inbox.tr(),
          isSelected: 1 == _currentIndex,
          primaryColor: context.colors.primary,
          onTap: () {
            context.showComingSoonDialog();
          },
        ),
      ],
    );
  }
}

class _SelectionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback? onTap;
  const _SelectionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Spacing.extraLarge),
        decoration: BoxDecoration(
          color: context.colors.onPrimary,
          borderRadius: BorderRadius.circular(Shape.large),
        ),
        child: Row(
          children: [
            // Custom Radio/Checkbox look
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                key: ValueKey<bool>(isSelected),
                color: isSelected ? primaryColor : Colors.grey[400],
                size: 28,
              ),
            ),
            const Gap(Spacing.extraLarge),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.typography.bold16),
                Text(
                  subtitle,
                  style: context.typography.regular10.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
