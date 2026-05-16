import 'package:equatable/equatable.dart';

class OfferModel extends Equatable {
  final String? id;
  final String productId;
  final String title;
  final num discountPercent;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OfferModel({
    this.id,
    required this.productId,
    required this.title,
    required this.discountPercent,
    required this.startsAt,
    required this.endsAt,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      id: map['id'] as String?,
      productId: map['product_id'] as String,
      title: map['title'] as String,
      discountPercent: map['discount_percent'] as num,
      startsAt: DateTime.parse(map['starts_at'] as String),
      endsAt: DateTime.parse(map['ends_at'] as String),
      isActive: map['is_active'] as bool,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'title': title,
      'discount_percent': discountPercent,
      'starts_at': startsAt.toUtc().toIso8601String(),
      'ends_at': endsAt.toUtc().toIso8601String(),
      'is_active': isActive,
    };
  }

  OfferModel copyWith({
    String? id,
    String? productId,
    String? title,
    num? discountPercent,
    DateTime? startsAt,
    DateTime? endsAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      discountPercent: discountPercent ?? this.discountPercent,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.parse(value as String);
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    title,
    discountPercent,
    startsAt,
    endsAt,
    isActive,
    createdAt,
    updatedAt,
  ];
}
