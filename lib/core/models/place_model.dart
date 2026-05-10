import 'package:equatable/equatable.dart';

class PlaceModel extends Equatable {
  final String id;
  final String street;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;
  final double lat;
  final double lng;

  const PlaceModel({
    required this.id,
    required this.street,
    required this.lat,
    required this.lng,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> json) {
    final center = json['center'] as List;
    final context = (json['context'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    String? ctx(String prefix) =>
        context.firstWhere(
              (c) => (c['id'] as String).startsWith(prefix),
              orElse: () => {},
            )['text']
            as String?;

    return PlaceModel(
      id: json['id'] as String,
      street: json['text'] as String? ?? json['place_name'] as String? ?? '',
      lat: (center[1] as num).toDouble(),
      lng: (center[0] as num).toDouble(),
      zip: ctx('postcode.'),
      city: ctx('place.'),
      state: ctx('region.'),
      country: ctx('country.'),
    );
  }

  @override
  List<Object?> get props => [id];
}
