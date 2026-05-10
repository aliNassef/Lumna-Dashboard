part of 'notification_cubit.dart';

enum NotificationStatus {
  initial,
  pickingImage,
  sending,
  success,
  failure,
}

extension NotificationStatusX on NotificationStatus {
  bool get isInitial => this == NotificationStatus.initial;
  bool get isPickingImage => this == NotificationStatus.pickingImage;
  bool get isSending => this == NotificationStatus.sending;
  bool get isSuccess => this == NotificationStatus.success;
  bool get isFailure => this == NotificationStatus.failure;
}

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.failure,
    this.pickedImage,
  });

  final NotificationStatus status;
  final Failure? failure;
  final XFile? pickedImage;

  NotificationState copyWith({
    NotificationStatus? status,
    Failure? failure,
    XFile? pickedImage,
    bool clearFailure = false,
    bool clearImage = false,
  }) {
    return NotificationState(
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
      pickedImage: clearImage ? null : pickedImage ?? this.pickedImage,
    );
  }

  @override
  List<Object?> get props => [status, failure, pickedImage];
}
