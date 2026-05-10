// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String name;
  final String imageUrl;
  final String? slug;
  final String? id;
  final int productCount;
  const CategoryModel({
    required this.name,
    required this.imageUrl,
    this.slug,
      this.id,
    required this.productCount,
  });

  @override
  List<Object> get props => [name, imageUrl];

  Map<String, dynamic> toMap() {
    final String slugData = name.toLowerCase().trim().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '-',
    );
    return <String, dynamic>{
      'name': name,
      'slug': slugData,
      'image_url': imageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    int productCount = 0;
    final productsData = map['products'];
    if (productsData is List && productsData.isNotEmpty) {
      // When using .select('..., products(count)'), Supabase returns an array of aggregated objects
      productCount = (productsData.first['count'] as num?)?.toInt() ?? 0;
    } else if (productsData is Map<String, dynamic>) {
      // Sometimes returns a single object
      productCount = (productsData['count'] as num?)?.toInt() ?? 0;
    }
    return CategoryModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      productCount: productCount,
      slug: map['slug'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  CategoryModel copyWith({
    String? name,
    String? imageUrl,
    String? slug,
    int? productCount,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      slug: slug ?? this.slug,
      productCount: productCount ?? this.productCount,
    );
  }
}
