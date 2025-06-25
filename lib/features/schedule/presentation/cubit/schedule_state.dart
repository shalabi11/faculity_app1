// lib/features/schedule/presentation/cubit/schedule_state.dart

part of 'schedule_cubit.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleSuccess extends ScheduleState {
  final List<ScheduleEntry> schedule;
  ScheduleSuccess(this.schedule);
}

class ScheduleFailure extends ScheduleState {
  final String message;
  ScheduleFailure(this.message);
}
