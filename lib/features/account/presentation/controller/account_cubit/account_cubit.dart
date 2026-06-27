import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/storage_paths.dart';
import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/exceptions/server_exception.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../../../core/services/storage/storage_service.dart';
import '../../../../auth/data/repo/auth_repo.dart';
import '../../../data/models/account_model.dart';
import '../../../data/repo/account_repo.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required this.accountRepo,
    required this.authRepo,
    required this.imagePicker,
    required this.storage,
  }) : super(const AccountState());

  final AccountRepo accountRepo;
  final AuthRepo authRepo;
  final ImagePickerService imagePicker;
  final StorageService storage;

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

  Future<void> updateAvatar() async {
    final currentProfile = state.profile;
    if (currentProfile == null) {
      emit(
        state.copyWith(
          status: AccountStatus.updateProfileFailure,
          failure: const Failure(errMessage: 'Profile not loaded'),
        ),
      );
      return;
    }

    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    emit(
      state.copyWith(
        status: AccountStatus.updatingProfile,
        clearFailure: true,
      ),
    );

    try {
      final avatarUrl = await storage.uploadImage(
        bucket: StoragePaths.avatarImagesBucket,
        // Storage RLS requires the first folder segment to be the user's id.
        folder: currentProfile.id,
        bytes: await image.readAsBytes(),
        fileName: image.name,
        upsert: true,
      );

      await updateProfile(currentProfile.copyWith(avatarUrl: avatarUrl));
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.updateProfileFailure,
          failure: Failure(errMessage: e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.updateProfileFailure,
          failure: Failure(errMessage: e.toString()),
        ),
      );
    }
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
