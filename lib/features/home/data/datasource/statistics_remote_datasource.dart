import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';

import '../models/dashboard_data_model.dart';

abstract interface class StatisticsRemoteDataSource {
  Future<DashboardStatsModel> getDashboardSummary();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final Database _database;

  StatisticsRemoteDataSourceImpl(this._database);

  @override
  Future<DashboardStatsModel> getDashboardSummary() async {
    final response = await _database.rpc(
      function: Endpoints.getDashboardSummary,
    );
    return DashboardStatsModel.fromMap(response);
  }
}
