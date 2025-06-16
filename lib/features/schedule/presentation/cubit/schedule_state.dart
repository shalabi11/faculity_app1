import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleEntry> schedule;
  ScheduleLoaded(this.schedule);
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}
