part of 'statistics_cubit.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final List<CardStatsModel> stats;

  const StatisticsLoaded({required this.stats});

  @override
  List<Object?> get props => [stats];
}

final class StatisticsError extends StatisticsState {
  final Failure failure;

  const StatisticsError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
