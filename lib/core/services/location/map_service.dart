import '../../models/place_model.dart';

abstract class MapService {
  Future<List<PlaceModel>> searchPlaces(
    String query,
  );

  Future<PlaceModel> reverseGeocode({
    required double lat,
    required double lng,
  });
}
