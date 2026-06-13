import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/storage_paths.dart';
import '../../../../../core/services/notification/remote_notification_service.dart';
import '../../../../../core/translation/locale_keys.g.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../../../core/services/storage/storage_service.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/models/send_notification_request.dart';
import '../../../data/repo/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.notificationRepo,
    required this.imagePickerService,
    required this.storageService,
    required this.remoteNotificationService,
  }) : super(const NotificationState());

  final NotificationRepo notificationRepo;
  final RemoteNotificationService remoteNotificationService;
  final ImagePickerService imagePickerService;
  final StorageService storageService;

  Future<void> pickImage() async {
    emit(
      state.copyWith(
        status: NotificationStatus.pickingImage,
        clearFailure: true,
      ),
    );

    final image = await imagePickerService.pickImage(
      imageQuality: 85,
      maxWidth: 1600,
      source: ImageSource.gallery,
    );

    emit(
      state.copyWith(
        status: NotificationStatus.initial,
        pickedImage: image,
        clearFailure: true,
      ),
    );
  }

  Future<void> sendNotification(SendNotificationRequest request) async {
    emit(
      state.copyWith(
        status: NotificationStatus.sending,
        clearFailure: true,
      ),
    );

    String? imageUrl;
    if (state.pickedImage != null) {
      try {
        final bytes = await state.pickedImage!.readAsBytes();
        imageUrl = await storageService.uploadImage(
          bucket: StoragePaths.categoryImagesBucket,
          folder: StoragePaths.categoryImagesFolder,
          fileName: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          bytes: bytes,
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: NotificationStatus.failure,
            failure: Failure(
              errMessage: LocaleKeys.error_failed_to_upload_image.tr(),
            ),
          ),
        );
        return;
      }
    }

    final updatedRequest = SendNotificationRequest(
      title: request.title,
      body: request.body,
      type: request.type,
      imageUrl: imageUrl,
    );

    final result = await notificationRepo.sendNotification(updatedRequest);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.failure,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: NotificationStatus.success,
          clearFailure: true,
        ),
      ),
    );
  }

  void resetForm() {
    emit(
      state.copyWith(
        status: NotificationStatus.initial,
        clearFailure: true,
        clearImage: true,
      ),
    );
  }

  // fetch notification history and mark notification is readed or not.

  void fetchNotificationHistory() async {
    emit(
      state.copyWith(
        status: NotificationStatus.fetchingHistory,
      ),
    );
    final notificationsOrFailure = await notificationRepo
        .fetchNotificationHistory();
    notificationsOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.failureFetchHistory,
          failure: failure,
        ),
      ),
      (notifications) => emit(
        state.copyWith(
          status: NotificationStatus.successFetchHistory,
          readedIds: notifications
              .where((notification) => notification.isRead)
              .map((notification) => notification.id)
              .toSet(),
          notificationHistory: notifications,
        ),
      ),
    );
  }

  void markAsRead(String notificationId) async {
    final previousHistory = state.notificationHistory;
    emit(
      state.copyWith(
        status: NotificationStatus.successMarkAsRead,
        readedIds: {...state.readedIds, notificationId},
        notificationHistory: state.notificationHistory
            .map(
              (notification) => notification.id == notificationId
                  ? notification.copyWith(isRead: true)
                  : notification,
            )
            .toList(),
      ),
    );
    final notificationOrFailure = await notificationRepo.markAsRead(
      notificationId,
    );
    notificationOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: NotificationStatus.failureMarkAsRead,
          readedIds: {...state.readedIds}..remove(notificationId),
          notificationHistory: previousHistory,
          failure: failure,
        ),
      ),
      (_) {},
    );
  }
}
