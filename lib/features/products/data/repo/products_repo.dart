import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/products_remote_datasource.dart';
import '../models/product_model.dart';

abstract interface class ProductsRepo {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, Unit>> addProduct(ProductModel product);
  Future<Either<Failure, Unit>> updateProduct(ProductModel product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
}

class ProductsRepoImpl implements ProductsRepo {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final products = await _remoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addProduct(ProductModel product) async {
    try {
      await _remoteDataSource.addProduct(product);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(ProductModel product) async {
    try {
      await _remoteDataSource.updateProduct(product);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      await _remoteDataSource.deleteProduct(id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
