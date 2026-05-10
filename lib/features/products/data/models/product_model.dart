// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../core/utils/app_assets.dart';

class ProductModel extends Equatable {
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';

  final String? id;
  final String categoryId;
  final bool isActive;
  final String name;
  final String description;
  final num price;
  final num? salePrice;
  final int stockQuantity;
  final num? avgRating;
  final num? reviewCount;
  final List<String> images;

  const ProductModel({
    this.avgRating,
    this.reviewCount,
    this.id,
    required this.categoryId,
    required this.isActive,
    required this.name,
    required this.description,
    required this.price,
    this.salePrice,
    required this.stockQuantity,
    required this.images,
  });

  @override
  List<Object> get props {
    return [
      categoryId,
      isActive,
      name,
      description,
      price,
      stockQuantity,
      images,
    ];
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final isActive = map['is_active'] as bool;
    return ProductModel(
      id: map['id'] as String,
      categoryId: map['category_id'] as String,
      isActive: isActive,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as num,
      salePrice: map['sale_price'] as num?,
      stockQuantity: map['stock_quantity'] as int,
      avgRating: map['avg_rating'] as num?,
      reviewCount: map['review_count'] as num?,
      images: List<String>.from(
        ((map['images'] as List<dynamic>).cast<String>()),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'is_active': isActive,
      'name': name,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'stock_quantity': stockQuantity,
      'images': images,
    };
  }

  ProductModel copyWith({
    String? id,
    String? categoryId,
    bool? isActive,
    String? name,
    String? description,
    num? price,
    num? salePrice,
    int? stockQuantity,
    num? avgRating,
    num? reviewCount,
    List<String>? images,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      avgRating: avgRating ?? this.avgRating,
      reviewCount: reviewCount ?? this.reviewCount,
      images: images ?? this.images,
    );
  }
}

List<ProductModel> dummyProducts = [
  const ProductModel(
    id: '1',
    categoryId: 'cat1',
    isActive: true,
    name: 'Product 1',
    description: 'High quality product',
    price: 99.99,
    salePrice: 79.99,
    stockQuantity: 50,
    images: [AppNetworkImage.dummy],
  ),
  const ProductModel(
    id: '2',
    categoryId: 'cat2',
    isActive: true,
    name: 'Product 2',
    description: 'Premium quality item',
    price: 149.99,
    salePrice: 119.99,
    stockQuantity: 30,
    images: [AppNetworkImage.dummy],
  ),
  const ProductModel(
    id: '3',
    categoryId: 'cat1',
    isActive: true,
    name: 'Product 3',
    description: 'Best seller product',
    price: 59.99,
    salePrice: 49.99,
    stockQuantity: 100,
    images: [AppNetworkImage.dummy],
  ),
];
