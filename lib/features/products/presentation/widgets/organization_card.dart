import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/di/di.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class OrganizationCard extends StatefulWidget {
  const OrganizationCard({super.key, required this.onCategoryChanged});
  final ValueChanged<String> onCategoryChanged;
  @override
  State<OrganizationCard> createState() => _OrganizationCardState();
}

class _OrganizationCardState extends State<OrganizationCard> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<CategoryCubit>()..getCategories(),
      child: Builder(
        builder: (context) {
          return Card(
            elevation: 0,
            color: context.colors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.extraLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.organization.tr(),
                    style: context.typography.bold24.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                  const Gap(32),

                  // Category Label
                  Text(
                    LocaleKeys.category.tr(),
                    style: context.typography.bold16.copyWith(
                      color: context.colors.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const Gap(Spacing.large),

                  // Dropdown Field
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return switch (state) {
                        GetCategoriesLoading() => Skeletonizer(
                          enabled: true,
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            hint: Text(
                              LocaleKeys.select_a_category.tr(),
                              style: context.typography.regular16.copyWith(
                                color: const Color(
                                  0xff617589,
                                ), // Matching your hint color
                              ),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.colors.onSurfaceVariant,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: context
                                  .colors
                                  .onPrimary, // Matches your form field fill
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Spacing.extraLarge,
                                horizontal: Spacing.large,
                              ),
                              border: _buildBorder(context),
                              enabledBorder: _buildBorder(context),
                              focusedBorder: _buildBorder(context),
                            ),
                            items: ['Furniture', 'Plants', 'Decor']
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                              widget.onCategoryChanged(value!);
                            },
                          ),
                        ),
                        GetCategoriesLoaded(:final categories) =>
                          DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            hint: Text(
                              LocaleKeys.select_a_category.tr(),
                              style: context.typography.regular16.copyWith(
                                color: const Color(
                                  0xff617589,
                                ), // Matching your hint color
                              ),
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: context.colors.onSurfaceVariant,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: context
                                  .colors
                                  .onPrimary, // Matches your form field fill
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: Spacing.extraLarge,
                                horizontal: Spacing.large,
                              ),
                              border: _buildBorder(context),
                              enabledBorder: _buildBorder(context),
                              focusedBorder: _buildBorder(context),
                            ),
                            items: categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category.id,
                                    child: Text(category.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                              widget.onCategoryChanged(value!);
                            },
                          ),
                        GetCategoriesError() => throw UnimplementedError(),
                        _ => const SizedBox.shrink(),
                      };
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  OutlineInputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Shape.large)),
      borderSide: BorderSide(color: context.colors.outline),
    );
  }
}
