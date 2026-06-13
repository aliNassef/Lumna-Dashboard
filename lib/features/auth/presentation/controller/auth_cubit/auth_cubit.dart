import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/services/notification/remote_notification_service.dart';
import '../../../data/models/signup_request.dart';
import '../../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());
  final AuthRepo authRepo;
  void signup(SignupRequest req) async {
    emit(AuthLoading());
    final signedOrfailure = await authRepo.signUp(req);
    signedOrfailure.fold(
      (failure) => emit(AuthError(failure: failure)),
      (success) => emit(AuthSuccess()),
    );
  }

  void signin({required String email, required String password}) async {
    emit(AuthLoading());
    final signinOrFailure = await authRepo.signIn(
      email,
      password,
    );
    signinOrFailure.fold(
      (failure) => emit(AuthError(failure: failure)),
      (success) {
        RemoteNotificationService.instance.init();
        emit(AuthSuccess());
      },
    );
  }
}
