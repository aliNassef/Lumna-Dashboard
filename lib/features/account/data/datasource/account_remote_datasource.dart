import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';
import '../../../../core/exceptions/server_exception.dart';
import '../../../../core/services/auth/auth_service.dart';
import '../models/account_model.dart';

abstract interface class AccountRemoteDataSource {
  Future<AccountModel> getCurrentProfile();
  Future<void> updateProfile(AccountModel profile);
}

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final Database _database;
  final AuthService _authService;

  AccountRemoteDataSourceImpl({
    required Database database,
    required AuthService authService,
  }) : _database = database,
       _authService = authService;

  @override
  Future<AccountModel> getCurrentProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      throw const ServerException('No authenticated user found');
    }

    final response = await _database.get(
      path: Endpoints.profiles,
      filterColumn: 'id',
      filterValue: currentUser.id,
      limit: 1,
    );

    if (response.isEmpty) {
      throw const ServerException('Profile not found');
    }

    return AccountModel.fromMap(response.first);
  }

  @override
  Future<void> updateProfile(AccountModel profile) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      throw const ServerException('No authenticated user found');
    }

    await _database.update(
      path: Endpoints.profiles,
      data: profile.toMap(),
      id: currentUser.id,
    );
  }
}
