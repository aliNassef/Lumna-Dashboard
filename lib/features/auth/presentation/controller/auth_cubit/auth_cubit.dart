import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/services/auth/deep_link_service.dart';
import '../../../../../core/services/notification/remote_notification_service.dart';
import '../../../../../core/translation/locale_keys.g.dart';
import '../../../data/models/signup_request.dart';
import '../../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial()) {
    _deepLinkSubscription = DeepLinkService.instance.stream.listen(_onDeepLink);
  }
  final AuthRepo authRepo;
  late final StreamSubscription<DeepLinkResult> _deepLinkSubscription;
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

  void signInWithGoogle() async {
    emit(AuthLoading());
    final signinOrFailure = await authRepo.signInWithGoogle();
    signinOrFailure.fold(
      (failure) => emit(AuthError(failure: failure)),
      // The external browser launched. The session arrives later through the
      // OAuth deep link, so success/failure is emitted from [_onDeepLink].
      (_) {},
    );
  }

  Future<void> _onDeepLink(DeepLinkResult result) async {
    if (result.type != DeepLinkType.googleLogin) return;

    final adminOrFailure = await authRepo.isCurrentUserAdmin();
    await adminOrFailure.fold(
      (failure) async {
        await authRepo.signOut();
        emit(AuthError(failure: failure));
      },
      (isAdmin) async {
        if (isAdmin) {
          RemoteNotificationService.instance.init();
          emit(AuthSuccess());
        } else {
          await authRepo.signOut();
          emit(
            AuthError(
              failure: Failure(errMessage: LocaleKeys.error_permission.tr()),
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    _deepLinkSubscription.cancel();
    return super.close();
  }
}
