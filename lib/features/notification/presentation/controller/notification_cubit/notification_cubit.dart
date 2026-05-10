import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../data/models/send_notification_request.dart';
import '../../../data/repo/notification_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required this.notificationRepo,
    required this.imagePickerService,
  }) : super(const NotificationState());

  final NotificationRepo notificationRepo;
  final ImagePickerService imagePickerService;

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

    final result = await notificationRepo.sendNotification(request);
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
}
