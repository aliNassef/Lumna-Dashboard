part of 'account_cubit.dart';

enum AccountStatus {
  initial,
  loadingProfile,
  profileLoaded,
  profileFailure,
  updatingProfile,
  updateProfileSuccess,
  updateProfileFailure,
  loggingOut,
  logoutSuccess,
  logoutFailure,
}

extension AccountStatusX on AccountStatus {
  bool get isInitial => this == AccountStatus.initial;
  bool get isLoadingProfile => this == AccountStatus.loadingProfile;
  bool get isProfileLoaded => this == AccountStatus.profileLoaded;
  bool get isProfileFailure => this == AccountStatus.profileFailure;
  bool get isUpdatingProfile => this == AccountStatus.updatingProfile;
  bool get isUpdateProfileSuccess => this == AccountStatus.updateProfileSuccess;
  bool get isUpdateProfileFailure => this == AccountStatus.updateProfileFailure;
  bool get isLoggingOut => this == AccountStatus.loggingOut;
  bool get isLogoutSuccess => this == AccountStatus.logoutSuccess;
  bool get isLogoutFailure => this == AccountStatus.logoutFailure;
}

class AccountState extends Equatable {
  final AccountStatus status;
  final AccountModel? profile;
  final Failure? failure;

  const AccountState({
    this.status = AccountStatus.initial,
    this.profile,
    this.failure,
  });

  AccountState copyWith({
    AccountStatus? status,
    AccountModel? profile,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return AccountState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, profile, failure];
}
