import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/category_remote_datasource.dart';
import '../model/category_model.dart';

abstract interface class CategoryRepo {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryModel category);
  Future<Either<Failure, void>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> deleteCategory(String slug);
}

class CategoryRepoImpl implements CategoryRepo {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryModel category) async {
    try {
      await _remoteDataSource.addCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryModel category) async {
    try {
      await _remoteDataSource.updateCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String slug) async {
    try {
      await _remoteDataSource.deleteCategory(slug);
      return const Right(null);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
