import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';

import '../models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final Database _database;

  ProductsRemoteDataSourceImpl(this._database);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await _database.get(
      path: Endpoints.products,
      orderBy: 'created_at',
      ascending: false,
    );

    return response.map(ProductModel.fromMap).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) {
    return _database.add(
      path: Endpoints.products,
      data: product.toMap(),
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) {
    return _database.update(
      path: Endpoints.products,
      id: product.id!,
      data: product.toMap(),
    );
  }

  @override
  Future<void> deleteProduct(String id) {
    return _database.delete(
      path: Endpoints.products,
      id: id,
    );
  }
}
