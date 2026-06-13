part of 'get_un_readed_count_cubit.dart';

sealed class GetUnReadedCountState extends Equatable {
  const GetUnReadedCountState();

  @override
  List<Object> get props => [];
}

final class GetUnReadedCountInitial extends GetUnReadedCountState {}
final class GetUnReadedCountLoading extends GetUnReadedCountState {}
final class GetUnReadedCountLoaded extends GetUnReadedCountState {
  final int count;
  const GetUnReadedCountLoaded({required this.count});
  @override
  List<Object> get props => [count];
}
final class GetUnReadedCountFailure extends GetUnReadedCountState {
  final Failure failure;
  const GetUnReadedCountFailure({required this.failure});
  @override
  List<Object> get props => [failure];  
}
