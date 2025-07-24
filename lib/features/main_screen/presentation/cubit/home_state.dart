import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class TodaysScheduleLoading extends HomeState {}

class TodaysScheduleLoaded extends HomeState {
  final List<ScheduleEntity> entries;
  TodaysScheduleLoaded(this.entries);
}

class TodaysScheduleError extends HomeState {
  final String message;
  TodaysScheduleError(this.message);
}
