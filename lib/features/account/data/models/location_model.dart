import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final double storeLng;
  final double storeLat;

  const LocationModel({
    required this.storeLng,
    required this.storeLat,
  });

  @override
  List<Object> get props => [storeLng, storeLat];

  LocationModel copyWith({
    double? storeLng,
    double? storeLat,
  }) {
    return LocationModel(
      storeLng: storeLng ?? this.storeLng,
      storeLat: storeLat ?? this.storeLat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'store_lng': storeLng,
      'store_lat': storeLat,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      storeLng: map['store_lng'] as double,
      storeLat: map['store_lat'] as double,
    );
  }
}
