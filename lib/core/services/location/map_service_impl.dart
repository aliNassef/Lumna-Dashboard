import 'package:dio/dio.dart';
import '../../logging/logger.dart';
import '../../models/place_model.dart';
import 'map_service.dart';

class MapServiceImpl implements MapService {
  final Dio dio;

  MapServiceImpl(this.dio);

  final _token =
      'pk.eyJ1IjoiYWxpLW5hc3NlZiIsImEiOiJjbW94NndiOTkwMXBuMnNzZHZ0aTVpZHppIn0.-VfAJu3mtd7qDd9GSHRDbg';

  @override
  Future<List<PlaceModel>> searchPlaces(String query) async {
    final encoded = Uri.encodeComponent(query);

    final response = await dio.get<Map<String, dynamic>>(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$encoded.json',
      queryParameters: {
        'access_token': _token,
        'limit': 10,
      },
      options: Options(
        headers: {'User-Agent': 'flutter_app'},
      ),
    );

    final features = response.data!['features'] as List<dynamic>;
    Logger.debug(features.toString());
    return features
        .map((e) => PlaceModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<PlaceModel> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$lng,$lat.json',
      queryParameters: {
        'access_token': _token,
        'limit': 1,
      },
      options: Options(
        headers: {'User-Agent': 'flutter_app'},
      ),
    );

    final features = response.data!['features'] as List<dynamic>;
    if (features.isEmpty) {
      throw Exception('No address found for this location.');
    }

    return PlaceModel.fromMap(features.first as Map<String, dynamic>);
  }
}
