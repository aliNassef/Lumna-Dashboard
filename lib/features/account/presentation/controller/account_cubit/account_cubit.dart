import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../auth/data/repo/auth_repo.dart';
import '../../../data/models/account_model.dart';
import '../../../data/repo/account_repo.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required this.accountRepo,
    required this.authRepo,
  }) : super(const AccountState());

  final AccountRepo accountRepo;
  final AuthRepo authRepo;

  Future<void> getCurrentProfile() async {
    emit(
      state.copyWith(
        status: AccountStatus.loadingProfile,
        clearFailure: true,
      ),
    );

    final profileOrFailure = await accountRepo.getCurrentProfile();
    profileOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.profileFailure,
          failure: failure,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: AccountStatus.profileLoaded,
          profile: profile,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> updateProfile(AccountModel profile) async {
    emit(
      state.copyWith(
        status: AccountStatus.updatingProfile,
        clearFailure: true,
      ),
    );

    final updateProfileOrFailure = await accountRepo.updateProfile(profile);
    updateProfileOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.updateProfileFailure,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AccountStatus.updateProfileSuccess,
          profile: profile,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> logout() async {
    emit(
      state.copyWith(
        status: AccountStatus.loggingOut,
        clearFailure: true,
      ),
    );

    final logoutOrFailure = await authRepo.signOut();
    logoutOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: AccountStatus.logoutFailure,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AccountStatus.logoutSuccess,
          clearFailure: true,
        ),
      ),
    );
  }
}
