import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';

import '../../../../core/logging/logger.dart';
import '../model/category_model.dart';

abstract interface class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String slug);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Database _database;

  CategoryRemoteDataSourceImpl(this._database);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _database.get(
      path: Endpoints.categories,
      orderBy: 'name',
      columns:
          'id, name, slug, image_url, created_at, products(count)',
    );
    Logger.info(response.toString());
    return response.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<void> addCategory(CategoryModel category) {
    return _database.add(
      path: Endpoints.categories,
      data: category.toMap(),
    );
  }

  @override
  Future<void> updateCategory(CategoryModel category) {
    return _database.updateWhere(
      path: Endpoints.categories,
      data: category.toMap(),
      filters: [
        {'column': 'slug', 'value': category.slug},
      ],
    );
  }

  @override
  Future<void> deleteCategory(String slug) {
    return _database.deleteWhere(
      path: Endpoints.categories,
      filters: [
        {'column': 'slug', 'value': slug},
      ],
    );
  }
}
