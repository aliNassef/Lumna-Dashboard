import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controller/category_cubit/category_cubit.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';

class CustomCategoryDropDownMenu extends StatefulWidget {
  const CustomCategoryDropDownMenu({
    super.key,
    required this.onCategoryChanged,
    this.selectedCategory,
  });
  final ValueChanged<String> onCategoryChanged;
  final String? selectedCategory;
  @override
  State<CustomCategoryDropDownMenu> createState() =>
      _CustomCategoryDropDownMenuState();
}

class _CustomCategoryDropDownMenuState
    extends State<CustomCategoryDropDownMenu> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        return switch (state) {
          GetCategoriesLoading() => Skeletonizer(
            enabled: true,
            child: DropdownButtonFormField<String>(
              initialValue: null,
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
                fillColor:
                    context.colors.onPrimary, // Matches your form field fill
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
                fillColor:
                    context.colors.onPrimary, // Matches your form field fill
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
    );
  }

  OutlineInputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(Shape.large)),
      borderSide: BorderSide(color: context.colors.outline),
    );
  }
}
