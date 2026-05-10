import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/widgets/custom_app_bar.dart';

import '../../../../core/utils/spacer.dart';
import '../../data/models/product_args.dart';
import '../widgets/edit_product_view_body.dart';

class EditProductView extends StatelessWidget {
  const EditProductView({super.key, required this.productArgs});
  static const routeName = 'edit-product';
  final ProductArgs productArgs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: LocaleKeys.products.tr(),
        showBackButton: true,
        actionPadding: 20,
      ),
      body: BlocProvider.value(
        value: productArgs.productCubit,
        child: SafeArea(
          child: SingleChildScrollView(
            child: EditProductViewBody(product: productArgs.product)
                .withHorizontalPadding(
                  Spacing.extraLarge,
                ),
          ),
        ),
      ),
    );
  }
}
