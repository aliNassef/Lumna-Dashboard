import 'package:equatable/equatable.dart';

import '../../presentation/controller/product_cubit/product_cubit.dart';
import 'product_model.dart';

class ProductArgs extends Equatable {
  final ProductModel product;
  final ProductCubit productCubit;

  const ProductArgs({required this.product, required this.productCubit});
  @override
  List<Object?> get props => [product, productCubit];
}
