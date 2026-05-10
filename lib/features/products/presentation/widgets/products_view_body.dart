import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../data/models/product_model.dart';
import '../controller/product_cubit/product_cubit.dart';
import 'product_card_item.dart';

class ProductsViewBody extends StatelessWidget {
  const ProductsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.filteredProducts != current.filteredProducts,
      builder: (context, state) {
        final totalItems = state.filteredProducts.length;

        return CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.person, color: context.colors.onPrimary),
                  ),
                ),
              ],
              title: Text(
                '$totalItems Total Items',
                style: context.typography.bold24.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child:
                  CustomSearchBar(
                    onChanged: context.read<ProductCubit>().searchProducts,
                  ).withHorizontalPadding(
                    Spacing.extraLarge,
                  ),
            ),
            const SliverGap(Spacing.extraLarge),
            ...switch (state.status) {
              ProductStatus.loadingProducts => [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.extraLarge,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => Skeletonizer(
                      enabled: true,
                      child: ProductCardItem(
                        product: dummyProducts[index % dummyProducts.length],
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const Gap(Spacing.extraLarge),
                    itemCount: 3,
                  ),
                ),
              ],
              ProductStatus.successProducts ||
              ProductStatus.initial ||
              ProductStatus.addProductSuccess ||
              ProductStatus.updatingProduct ||
              ProductStatus.updateProductSuccess ||
              ProductStatus.updateProductFailure ||
              ProductStatus.deletingProduct ||
              ProductStatus.deleteProductSuccess ||
              ProductStatus.deleteProductFailure => [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.extraLarge,
                  ),
                  sliver: SliverList.separated(
                    itemBuilder: (context, index) => ProductCardItem(
                      product: state.filteredProducts[index],
                    ),
                    separatorBuilder: (context, index) =>
                        const Gap(Spacing.extraLarge),
                    itemCount: state.filteredProducts.length,
                  ),
                ),
              ],
              ProductStatus.failureProducts => [
                SliverToBoxAdapter(
                  child: CustomFailureWidget(failure: state.failure!),
                ),
              ],
              _ => const [
                SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                ),
              ],
            },
            const SliverGap(Spacing.extraExtraLarge),
          ],
        );
      },
    );
  }
}
