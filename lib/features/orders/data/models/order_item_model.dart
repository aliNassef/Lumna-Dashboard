import 'package:equatable/equatable.dart';

/// Represents a single order line item returned from Supabase.
class OrderItemModel extends Equatable {
  final String id;
  final String title;
  final num unitPrice;
  final num totalPrice;
  final int quantity;
  final String? imageUrl;

  const OrderItemModel({
    required this.id,
    required this.title,
    required this.unitPrice,
    required this.totalPrice,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    final product = map['products'] as Map<String, dynamic>?;
    final quantity = (map['quantity'] as num?)?.toInt() ?? 0;
    final unitPrice =
        (map['unit_price'] as num?) ?? (product?['price'] as num?) ?? 0;

    return OrderItemModel(
      id: map['id'] as String? ?? '',
      title: _resolveTitle(map, product),
      unitPrice: unitPrice,
      totalPrice: unitPrice * quantity,
      quantity: quantity,
      imageUrl: _resolveImageUrl(product),
    );
  }

  static String _resolveTitle(
    Map<String, dynamic> item,
    Map<String, dynamic>? product,
  ) {
    final title = _readString(
      item,
      keys: const ['product_name', 'title', 'name'],
      fallbackMap: product,
      fallbackKeys: const ['name'],
    );
    if (title == null || title.trim().isEmpty) {
      return 'Unknown Item';
    }
    return title;
  }

  static String? _resolveImageUrl(Map<String, dynamic>? product) {
    if (product == null) {
      return null;
    }

    final images = product['images'];
    if (images is List) {
      for (final image in images) {
        final normalized = (image as String?)?.trim();
        if (normalized != null && normalized.isNotEmpty) {
          return normalized;
        }
      }
    }

    return null;
  }

  static String? _readString(
    Map<String, dynamic> source, {
    required List<String> keys,
    Map<String, dynamic>? fallbackMap,
    List<String> fallbackKeys = const [],
  }) {
    for (final key in keys) {
      final value = source[key] as String?;
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    if (fallbackMap == null) {
      return null;
    }

    for (final key in fallbackKeys) {
      final value = fallbackMap[key] as String?;
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    unitPrice,
    totalPrice,
    quantity,
    imageUrl,
  ];
}
