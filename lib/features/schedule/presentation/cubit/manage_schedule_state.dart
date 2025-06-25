part of 'manage_schedule_cubit.dart';

abstract class ManageScheduleState {}

class ManageScheduleInitial extends ManageScheduleState {}

class ManageScheduleLoading extends ManageScheduleState {}

class ManageScheduleSuccess extends ManageScheduleState {
  final String message;
  ManageScheduleSuccess(this.message);
}

class ManageScheduleFailure extends ManageScheduleState {
  final String message;
  ManageScheduleFailure(this.message);
}
