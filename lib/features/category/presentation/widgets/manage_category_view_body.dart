import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';

import '../../../../core/extensions/mediaquery_size.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controller/category_cubit/category_cubit.dart';
import 'add_category_dialog.dart';
import 'category_list_builder.dart';

class ManageCategoryViewBody extends StatelessWidget {
  const ManageCategoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          backgroundColor: context.colors.onPrimary,
          title: CustomAppbar(
            title: LocaleKeys.app_name.tr(),
            showBackButton: true,
          ),
        ),
        const SliverGap(Spacing.extraLarge),
        SliverToBoxAdapter(
          child:
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    LocaleKeys.categories.tr(),
                    style: context.typography.bold24.copyWith(
                      color: context.colors.onSurface,
                    ),
                  ),
                  const Gap(Spacing.small),
                  Text(
                    LocaleKeys.categories_desc.tr(),
                    style: context.typography.regular16.copyWith(
                      color: context.colors.onTertiary,
                    ),
                  ),
                  const Gap(Spacing.extraLarge),
                  SizedBox(
                    width: context.width * .65,
                    child: CustomButton(
                      text: LocaleKeys.add_category.tr(),
                      onPressed: () {
                        showAddCategoryDialog(context);
                      },
                      icon: Icon(
                        Icons.add,
                        color: context.colors.onPrimary,
                      ),
                    ),
                  ),
                  const Gap(Spacing.extraLarge),
                ],
              ).withHorizontalPadding(
                Spacing.extraLarge,
              ),
        ),
        const CategoryListBuilder(),
        const SliverGap(Spacing.extraExtraLarge),
      ],
    );
  }

  void showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoryCubit>(),
        child: const AddCategoryDialog(),
      ),
    );
  }
}
