part of 'forgot_password_cubit.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordEmailSent extends ForgotPasswordState {}

final class ForgotPasswordUpdated extends ForgotPasswordState {}

final class ForgotPasswordError extends ForgotPasswordState {
  final Failure failure;

  const ForgotPasswordError({required this.failure});

  @override
  List<Object> get props => [failure];
}
