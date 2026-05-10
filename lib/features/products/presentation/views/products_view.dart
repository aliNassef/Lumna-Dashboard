import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../controller/product_cubit/product_cubit.dart';

import '../widgets/products_view_body.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});
  static const routeName = 'products_view';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ProductCubit>()..getProducts(),
      child: const Scaffold(
        body: SafeArea(
          child: ProductsViewBody(),
        ),
      ),
    );
  }
}
