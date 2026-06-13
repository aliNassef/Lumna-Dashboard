part of 'notification_cubit.dart';

enum NotificationStatus {
  initial,
  pickingImage,
  sending,
  success,
  failure,
  fetchingHistory,
  successFetchHistory,
  failureFetchHistory,
  markingAsRead,
  successMarkAsRead,
  failureMarkAsRead,
}

extension NotificationStatusX on NotificationStatus {
  bool get isInitial => this == NotificationStatus.initial;
  bool get isPickingImage => this == NotificationStatus.pickingImage;
  bool get isSending => this == NotificationStatus.sending;
  bool get isSuccess => this == NotificationStatus.success;
  bool get isFailure => this == NotificationStatus.failure;
  bool get isFetchingHistory => this == NotificationStatus.fetchingHistory;
  bool get isSuccessFetchHistory =>
      this == NotificationStatus.successFetchHistory;
  bool get isFailureFetchHistory =>
      this == NotificationStatus.failureFetchHistory;

  bool get isMarkingAsRead => this == NotificationStatus.markingAsRead;
  bool get isSuccessMarkAsRead => this == NotificationStatus.successMarkAsRead;
  bool get isFailureMarkAsRead => this == NotificationStatus.failureMarkAsRead;
}

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.failure,
    this.pickedImage,
    this.readedIds = const {},
    this.notificationHistory = const [],
  });

  final NotificationStatus status;
  final Failure? failure;
  final XFile? pickedImage;
  final Set<String> readedIds;
  final List<NotificationModel> notificationHistory;

  NotificationState copyWith({
    NotificationStatus? status,
    Failure? failure,
    XFile? pickedImage,
    bool clearFailure = false,
    bool clearImage = false,
    List<NotificationModel>? notificationHistory,
    Set<String>? readedIds,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notificationHistory: notificationHistory ?? this.notificationHistory,
      failure: clearFailure ? null : failure ?? this.failure,
      pickedImage: clearImage ? null : pickedImage ?? this.pickedImage,
      readedIds: readedIds ?? this.readedIds,
    );
  }

  @override
  List<Object?> get props => [
    status,
    failure,
    pickedImage,
    readedIds,
    notificationHistory,
  ];
}
