import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/navigation/navigation.dart';
import '../../data/models/product_args.dart';
import '../controller/product_cubit/product_cubit.dart';
import '../views/edit_product_view.dart';

import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../data/models/product_model.dart';

class ProductCardItem extends StatelessWidget {
  const ProductCardItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.images.isNotEmpty
        ? product.images.first
        : AppNetworkImage.dummy;
    final statusLabel = product.isActive ? LocaleKeys.badge_active.tr() : LocaleKeys.badge_inactive.tr();
    final statusColor = product.isActive ? Colors.green : Colors.red;
    final displayPrice = product.salePrice ?? product.price;

    return Container(
      padding: const EdgeInsets.all(Spacing.extraLarge),
      decoration: BoxDecoration(
        color: context.colors.onPrimary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Image Section with Badge and Edit Button
          Stack(
            children: [
              CustomNetworkImage(
                img: imageUrl,
                height: 250,
                width: double.infinity,
                radius: 20,
                fit: BoxFit.cover,
              ),
              // "ACTIVE" Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.onPrimary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,

                    style: context.typography.bold12.copyWith(
                      color: statusColor.withValues(
                        alpha: 0.8,
                      ), // context.colors.primary,
                    ),
                  ),
                ),
              ),

              // Floating Action Button (Edit)
            ],
          ),
          const Gap(Spacing.extraLarge),

          // 2. Text Details Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      product.name,
                      style: context.typography.bold20.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    const Gap(Spacing.medium),
                    Row(
                      children: [
                        Text(
                          '\$${displayPrice.toString()}',
                          style: context.typography.bold18.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const Gap(Spacing.small),
                        Text(
                          '•',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        const Gap(Spacing.small),
                        RichText(
                          text: TextSpan(
                            style: context.typography.regular14.copyWith(
                              color: Colors.grey[600],
                            ),
                            children: [
                              TextSpan(text: LocaleKeys.stock_label.tr()),
                              TextSpan(
                                text: product.stockQuantity.toString(),
                                style: context.typography.bold14.copyWith(
                                  color: context.colors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    EditProductView.routeName,
                    arguments: NavArgs(
                      data: ProductArgs(
                        product: product,
                        productCubit: context.read<ProductCubit>(),
                      ),
                      animation: NavAnimation.fade,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(Spacing.large),
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(Shape.large),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit,
                    color: context.colors.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
