import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../data/repo/auth_repo.dart';

part 'forgot_password_state.dart';

/// Drives the password-recovery flow: requesting a reset email and setting the
/// new password after the user returns through the reset deep link.
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required this.authRepo})
    : super(ForgotPasswordInitial());

  final AuthRepo authRepo;

  void sendResetEmail(String email) async {
    emit(ForgotPasswordLoading());
    final result = await authRepo.resetPassword(email);
    result.fold(
      (failure) => emit(ForgotPasswordError(failure: failure)),
      (_) => emit(ForgotPasswordEmailSent()),
    );
  }

  void updatePassword(String password) async {
    emit(ForgotPasswordLoading());
    final result = await authRepo.updatePassword(password);
    result.fold(
      (failure) => emit(ForgotPasswordError(failure: failure)),
      (_) => emit(ForgotPasswordUpdated()),
    );
  }
}
