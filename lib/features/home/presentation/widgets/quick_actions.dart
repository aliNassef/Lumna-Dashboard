import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/utils/shape.dart';
import '../../../category/presentation/views/manage_category_view.dart';
import '../../../products/presentation/views/create_new_product_view.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import 'quick_action_tile.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.outline.withValues(
          alpha: 0.4,
        ),
        borderRadius: BorderRadius.circular(Shape.extraLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.dashboard_quick_actions.tr(),
            style: context.typography.bold20.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(20),
          QuickActionTile(
            title: LocaleKeys.product_create_title.tr(),
            icon: Icons.add_circle_outline,
            onTap: () => context.pushNamed(CreateNewProductView.routeName),
          ),
          const Gap(12),
          QuickActionTile(
            title: LocaleKeys.categories_add.tr(),
            icon: Icons.create_new_folder_outlined,
            onTap: () => context.pushNamed(ManageCategoryView.routeName),
          ),
        ],
      ),
    );
  }
}
