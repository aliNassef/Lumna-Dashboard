import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../controller/product_cubit/product_cubit.dart';
import '../widgets/create_new_product_view_body.dart';

class CreateNewProductView extends StatelessWidget {
  const CreateNewProductView({super.key});
  static const String routeName = 'create-new-product';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: LocaleKeys.app_name.tr(),
        showBackButton: true,
        actionPadding: 20,
      ),
      body: BlocProvider(
        create: (context) => injector<ProductCubit>(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: const CreateNewProductViewBody().withHorizontalPadding(
              Spacing.extraLarge,
            ),
          ),
        ),
      ),
    );
  }
}
