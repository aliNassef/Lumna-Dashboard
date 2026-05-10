import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../category/presentation/widgets/custom_category_drop_down_menu.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/custom_switch.dart';
import '../../../category/presentation/controller/category_cubit/category_cubit.dart';

class CoreInformationCard extends StatelessWidget {
  const CoreInformationCard({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.isActive,
    this.categoryId,
    required this.onActiveChanged,
    required this.onCategoryChanged,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final bool isActive;
  final ValueChanged<bool> onActiveChanged;
  final ValueChanged<String> onCategoryChanged;
  final String? categoryId;
  @override
  Widget build(BuildContext context) {
    final fieldFillColor = const Color(0xFFF1F4F3);

    return Container(
      padding: const EdgeInsets.all(Spacing.extraLarge),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Icon
          Row(
            children: [
              Icon(Icons.info, color: context.colors.primary, size: 24),
              const Gap(Spacing.medium),
              Text(
                LocaleKeys.section_core_information.tr(),
                style: context.typography.bold20.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
          const Gap(Spacing.extraLarge),

          // Product Name
          _buildLabel(context, LocaleKeys.label_product_name_upper.tr()),
          CustomTextFormField(
            controller: nameController,
            hintText: LocaleKeys.hint_ethereal_fern_vessel.tr(),
          ),
          const Gap(Spacing.large),

          // Description
          _buildLabel(context, LocaleKeys.label_description_upper.tr()),
          CustomTextFormField(
            controller: descriptionController,
            hintText: LocaleKeys.hint_hand_crafted_ceramic.tr(),
            maxLines: 5,
          ),
          const Gap(Spacing.large),

          // Category Dropdown (Simplified example)
          _buildLabel(context, LocaleKeys.label_category_upper.tr()),
          BlocProvider(
            create: (context) => injector<CategoryCubit>()..getCategories(),
            child: CustomCategoryDropDownMenu(
              selectedCategory: categoryId,
              onCategoryChanged: (categoryId) {
                onCategoryChanged(categoryId);
              },
            ),
          ),
          const Gap(Spacing.large),

          // Status Switch
          _buildLabel(context, LocaleKeys.label_status_upper.tr()),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.large,
              vertical: Spacing.large,
            ),
            decoration: BoxDecoration(
              color: fieldFillColor,
              borderRadius: BorderRadius.circular(Shape.large),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isActive ? LocaleKeys.product_status_active.tr() : LocaleKeys.product_status_inactive.tr(),
                  style: context.typography.medium16,
                ),
                CustomSwitch(
                  onToggle: (value) {
                    onActiveChanged(value);
                  },
                  value: isActive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.small),
      child: Text(
        label,
        style: context.typography.bold12.copyWith(
          color: const Color(0xFFB0C1D9), // Light blue-grey label color
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
