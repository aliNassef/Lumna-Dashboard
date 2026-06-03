import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/widgets/custom_switch.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const PreferenceTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.isSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      borderRadius: BorderRadius.circular(Shape.large),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Spacing.medium),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(Shape.medium),
            ),
            child: Icon(icon, color: context.colors.primary, size: 24),
          ),
          const Gap(Spacing.extraLarge),
          Expanded(
            child: Text(
              title,
              style: context.typography.semiBold16.copyWith(
                color: context.colors.onSurface,
              ),
            ),
          ),
          if (isSwitch)
            CustomSwitch(onToggle: (val) {})
          else ...[
            if (trailingText != null)
              Text(
                trailingText!,
                style: context.typography.medium14.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            const Gap(Spacing.medium),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ],
      ),
    );
  }
}
