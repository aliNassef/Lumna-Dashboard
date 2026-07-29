import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';

import '../models/product_model.dart';

abstract interface class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts();

  /// Total units sold for a product.
  ///
  /// Only orders that represent a realized sale are counted: an order line is
  /// included when its parent order's status is `shipped` or `delivered`.
  /// Cancelled, refunded, and not-yet-fulfilled orders (pending / confirmed /
  /// processing) are excluded.
  Future<int> getProductTotalSales(String id);
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

  @override
  Future<int> getProductTotalSales(String id) async {
    // Statuses that count as a realized sale.
    const soldStatuses = {'shipped', 'delivered'};

    // Fetch this product's order lines together with their parent order's
    // status. `orders!inner(...)` drops any line whose order is missing.
    final rows = await _database.get(
      path: Endpoints.orderItems,
      columns: 'quantity, orders!inner(status)',
      filterColumn: 'product_id',
      filterValue: id,
    );

    var totalUnits = 0;
    for (final row in rows) {
      final order = row['orders'] as Map<String, dynamic>?;
      final status = (order?['status'] as String?)?.toLowerCase();
      if (status == null || !soldStatuses.contains(status)) continue;

      totalUnits += (row['quantity'] as num?)?.toInt() ?? 0;
    }

    return totalUnits;
  }
}
