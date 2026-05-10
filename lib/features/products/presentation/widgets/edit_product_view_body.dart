import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/translation/locale_keys.g.dart';
import 'pricing_inventory_card.dart';
import 'product_edit_header.dart';
import 'product_media_picker_card.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/utils/spacer.dart';
import '../../data/models/product_model.dart';
import '../controller/product_cubit/product_cubit.dart';
import 'core_information_card.dart';
import 'deleting_product_button_listener.dart';
import 'total_sales_and_average_rating.dart';
import 'updating_product_button_bloc_listener.dart';

class EditProductViewBody extends StatefulWidget {
  const EditProductViewBody({super.key, required this.product});

  final ProductModel product;

  @override
  State<EditProductViewBody> createState() => _EditProductViewBodyState();
}

class _EditProductViewBodyState extends State<EditProductViewBody> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _stockQuantityController;
  late String categoryId;
  late final ProductCubit productCubit;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _salePriceController = TextEditingController(
      text: widget.product.salePrice?.toString() ?? '',
    );
    _stockQuantityController = TextEditingController(
      text: widget.product.stockQuantity.toString(),
    );
    categoryId = widget.product.categoryId;
    productCubit = context.read<ProductCubit>();
    productCubit.initializeForEdit(widget.product);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _stockQuantityController.dispose();
    productCubit.resetFormState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProductEditHeader(),
        const Gap(Spacing.extraLarge),
        BlocSelector<ProductCubit, ProductState, bool>(
          selector: (state) => state.isActive,
          builder: (context, isActive) {
            return CoreInformationCard(
              onCategoryChanged: (id) {
                categoryId = id;
              },
              onActiveChanged: (active) {
                Logger.error(active.toString());
                context.read<ProductCubit>().setIsActive(active);
              },
              nameController: _nameController,
              descriptionController: _descriptionController,
              isActive: isActive,
              categoryId: widget.product.categoryId,
            );
          },
        ),
        const Gap(Spacing.extraLarge),
        BlocSelector<
          ProductCubit,
          ProductState,
          ({List<XFile> pickedImages, List<String> retainedImageUrls})
        >(
          selector: (state) => (
            pickedImages: state.pickedImages,
            retainedImageUrls: state.retainedImageUrls,
          ),
          builder: (context, state) {
            return ProductMediaPickerCard(
              images: state.pickedImages,
              initialImageUrls: state.retainedImageUrls,
              onAddImages: () {
                context.read<ProductCubit>().pickImages();
              },
              onRemoveImage: (index) {
                context.read<ProductCubit>().removeEditImage(index);
              },
            );
          },
        ),
        const Gap(Spacing.extraLarge),
        PricingInventoryCard(
          labelColor: const Color(0xFFB0C1D9),
          titleColor: context.colors.primary,
          salePrice: _salePriceController,
          price: _priceController,
          stockQuantity: _stockQuantityController,
        ),
        const Gap(Spacing.extraLarge),
        TotalSalesAndAvgRating(product: widget.product),
        const Gap(Spacing.extraLarge),
        UpdatingProductBuuttonListener(
          product: widget.product,
          nameController: _nameController,
          descriptionController: _descriptionController,
          priceController: _priceController,
          salePriceController: _salePriceController,
          stockQuantityController: _stockQuantityController,
          categoryId: categoryId,
        ),
        const Gap(Spacing.extraLarge),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            LocaleKeys.cancel_changes.tr(),
            style: context.typography.bold18.copyWith(
              color: context.colors.primary,
            ),
          ),
        ),
        const Gap(Spacing.extraLarge),
        DeletingProductButtonListener(id: widget.product.id!),
        const Gap(Spacing.extraExtraLarge),
      ],
    );
  }
}
