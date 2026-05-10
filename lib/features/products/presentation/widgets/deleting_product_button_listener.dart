import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../layout/presentation/views/layout_view.dart';
import '../controller/product_cubit/product_cubit.dart';

class DeletingProductButtonListener extends StatelessWidget {
  const DeletingProductButtonListener({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      listener: (context, state) {
        if (state.status.isDeletingProduct) {
          context.showLoadingBox();
        }
        if (state.status.isDeleteProductSuccess) {
          context.showToast(
            text: 'Product deleted successfully',
            backgroundColor: context.colors.primary,
          );
          context.popUntil(LayoutView.routeName);
        }

        if (state.status.isDeleteProductFailure && state.failure != null) {
          context.showToast(
            text: state.failure!.errMessage,
            backgroundColor: context.colors.error,
          );
        }
      },
      child: TextButton(
        onPressed: () {
          context.read<ProductCubit>().deleteProduct(id);
        },
        child: Text(
          LocaleKeys.delete_product.tr(),
          style: context.typography.bold18.copyWith(
            color: context.colors.error,
          ),
        ),
      ),
    );
  }
}
