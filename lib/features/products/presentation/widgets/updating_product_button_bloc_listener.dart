import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumna_admin/core/navigation/navigation.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/product_model.dart';
import '../controller/product_cubit/product_cubit.dart';

class UpdatingProductBuuttonListener extends StatelessWidget {
  const UpdatingProductBuuttonListener({
    super.key,
    required this.product,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
    required TextEditingController salePriceController,
    required TextEditingController stockQuantityController,
    required this.categoryId,
  }) : _nameController = nameController,
       _descriptionController = descriptionController,
       _priceController = priceController,
       _salePriceController = salePriceController,
       _stockQuantityController = stockQuantityController;

  final ProductModel product;
  final TextEditingController _nameController;
  final TextEditingController _descriptionController;
  final TextEditingController _priceController;
  final TextEditingController _salePriceController;
  final TextEditingController _stockQuantityController;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state.status.isUpdatingProduct || state.status.isUploadingImages) {
          context.showLoadingBox();
        }

        if (state.status.isUpdateProductSuccess) {
          context.showToast(
            text: 'Product updated successfully',
            backgroundColor: context.colors.primary,
          );
          context.popUntil(LayoutView.routeName);
        }

        if (state.status.isUpdateProductFailure && state.failure != null) {
          context.showToast(
            text: state.failure!.errMessage,
            backgroundColor: context.colors.error,
          );
        }
      },
      child: CustomButton(
        text: LocaleKeys.save_changes.tr(),
        onPressed: () {
          final isActive = context.read<ProductCubit>().state.isActive;
          final updatedProduct = product.copyWith(
            name: _nameController.text,
            description: _descriptionController.text,
            price: double.parse(_priceController.text),
            salePrice: double.parse(_salePriceController.text),
            isActive: isActive,
            stockQuantity: int.parse(_stockQuantityController.text),
            categoryId: categoryId,
          );
          context.read<ProductCubit>().updateProduct(updatedProduct);
        },
      ),
    );
  }
}
