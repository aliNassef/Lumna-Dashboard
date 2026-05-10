import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../data/model/category_model.dart';
import '../controller/category_cubit/category_cubit.dart';
import 'category_card.dart';

class CategoryListBuilder extends StatelessWidget {
  const CategoryListBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (previous, current) =>
          current is GetCategoriesLoading ||
          current is GetCategoriesLoaded ||
          current is GetCategoriesError,
      builder: (context, state) {
        return switch (state) {
          GetCategoriesLoading() => SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.extraLarge,
            ),
            sliver: SliverList.separated(
              itemBuilder: (_, index) => const Skeletonizer(
                enabled: true,
                child: CategoryCard(
                  category: CategoryModel(
                    productCount: 2,
                    name: 'Furniture',
                    imageUrl:
                        'https://images.unsplash.com/photo-1505691938895-1758d7feb511?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZnVybml0dXJlfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60',
                  ),
                ),
              ),
              separatorBuilder: (_, _) => const Gap(Spacing.extraLarge),
              itemCount: 5,
            ),
          ),
          GetCategoriesLoaded(:final categories) => SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.extraLarge,
            ),
            sliver: SliverList.separated(
              itemBuilder: (_, index) => CategoryCard(
                category: categories[index],
              ),
              separatorBuilder: (_, _) => const Gap(Spacing.extraLarge),
              itemCount: categories.length,
            ),
          ),
          GetCategoriesError(failure: final failure) => SliverToBoxAdapter(
            child: CustomFailureWidget(failure: failure),
          ),
          _ => const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          ),
        };
      },
    );
  }
}
