import '../models/location_model.dart';

import '../../../../core/database/database.dart';

abstract class LocationRemoteDataSource {
  Future<void> addStoreLocation(LocationModel location);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  LocationRemoteDataSourceImpl(this._database);

  final Database _database;

  @override
  Future<void> addStoreLocation(LocationModel location) async {
    await Future.wait([
      _database.upsert(
        path: 'store_settings',
        data: {'key': 'store_lat', 'value': location.storeLat.toString()},
        onConflict: 'key',
      ),
      _database.upsert(
        path: 'store_settings',
        data: {'key': 'store_lng', 'value': location.storeLng.toString()},
        onConflict: 'key',
      ),
    ]);
  }
}
