import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumna_admin/core/di/di.dart';

import '../../../../../core/exceptions/failure.dart';

part 'get_un_readed_count_state.dart';

class GetUnReadedCountCubit extends Cubit<GetUnReadedCountState> {
  GetUnReadedCountCubit({required NotificationRepo notificationRepo}) : _notificationRepo = notificationRepo, super(GetUnReadedCountInitial());
  final NotificationRepo _notificationRepo;
  void getUnReadedCount() async {
    emit( GetUnReadedCountLoading());
     final countOrfailure = await _notificationRepo.getUnReadedCount();
    countOrfailure.fold(
      (failure) => emit(GetUnReadedCountFailure(failure: failure)),
      (count) => emit(GetUnReadedCountLoaded(count: count)),
    );
  }
}
