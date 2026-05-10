import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../layout/presentation/views/layout_view.dart';
import '../controller/product_cubit/product_cubit.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../data/models/product_model.dart';
import 'basic_information_card.dart';
import 'organization_card.dart';
import 'pricing_inventory_card.dart';
import 'product_media_picker_card.dart';
import 'product_action_card.dart';

class CreateProductContent extends StatefulWidget {
  const CreateProductContent({
    super.key,
  });

  @override
  State<CreateProductContent> createState() => _CreateProductContentState();
}

class _CreateProductContentState extends State<CreateProductContent> {
  late final TextEditingController name;
  late final TextEditingController description;
  late final TextEditingController price;
  late final TextEditingController salePrice;
  late final TextEditingController stockQuantity;
  late final TextEditingController categoryId;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    categoryId = TextEditingController();
    name = TextEditingController();
    description = TextEditingController();
    price = TextEditingController();
    stockQuantity = TextEditingController();
    salePrice = TextEditingController();
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    salePrice.dispose();
    stockQuantity.dispose();
    categoryId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Gap(32),
          BasicInformationCard(
            name: name,
            description: description,
          ),
          const Gap(32),
          PricingInventoryCard(
            price: price,
            stockQuantity: stockQuantity,
            salePrice: salePrice,
          ),
          const Gap(32),
          OrganizationCard(
            onCategoryChanged: (categoryIdValue) {
              categoryId.text = categoryIdValue;
            },
          ),
          const Gap(32),
          BlocSelector<ProductCubit, ProductState, List<XFile>>(
            selector: (state) => state.pickedImages,
            builder: (context, state) {
              return ProductMediaPickerCard(
                images: state,
                onAddImages: () {
                  context.read<ProductCubit>().pickImages();
                },
                onRemoveImage: (index) {
                  context.read<ProductCubit>().removeImage(index);
                },
              );
            },
          ),
          const Gap(32),
          BlocListener<ProductCubit, ProductState>(
            listener: (context, state) {
              if (state.status.isAddProductSuccess) {
                context.showInfoDialog(
                  title: LocaleKeys.product_added_title.tr(),
                  message: LocaleKeys.product_added_successfully.tr(),
                );
                context.popUntil(LayoutView.routeName);
              }
              if (state.status.isAddProductFailure && state.failure != null) {
                context.showToast(
                  text: state.failure!.errMessage,
                  backgroundColor: context.colors.error,
                );
              }
              if (state.status.isUploadingImages) {
                context.showLoadingBox();
              }
              if (state.status.isAddingProduct) {
                context.pop();
                context.showLoadingBox();
              }
            },
            child: ProductActionsCard(
              onPublish: () {
                if (!_formKey.currentState!.validate()) return;
                if (categoryId.text.isEmpty) {
                  context.showToast(
                    text: LocaleKeys.please_select_category.tr(),
                    backgroundColor: context.colors.error,
                  );
                  return;
                }
                final product = ProductModel(
                  categoryId: categoryId.text,
                  description: description.text,
                  isActive: true,
                  price: num.parse(price.text.trim()),
                  salePrice: num.parse(salePrice.text.trim()),
                  stockQuantity: int.parse(stockQuantity.text.trim()),
                  name: name.text,
                  images: [],
                );
                context.read<ProductCubit>().addProduct(product);
              },
              onSaveAsDraft: () {
                if (!_formKey.currentState!.validate()) return;
                if (categoryId.text.isEmpty) {
                  context.showToast(
                    text: LocaleKeys.please_select_category.tr(),
                    backgroundColor: context.colors.error,
                  );
                  return;
                }
                final product = ProductModel(
                  categoryId: categoryId.text,
                  description: description.text,
                  isActive: false,
                  price: num.parse(price.text),
                  salePrice: num.parse(price.text),
                  stockQuantity: int.parse(stockQuantity.text),
                  name: name.text,
                  images: [],
                );
                context.read<ProductCubit>().addProduct(product);
              },
            ),
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
