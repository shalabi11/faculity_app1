// lib/features/teachers/presentation/cubit/teacher_schedule_state.dart
part of 'teacher_schedule_cubit.dart';

abstract class TeacherScheduleState extends Equatable {
  const TeacherScheduleState();

  @override
  List<Object> get props => [];
}

class TeacherScheduleInitial extends TeacherScheduleState {}

class TeacherScheduleLoading extends TeacherScheduleState {}

class TeacherScheduleSuccess extends TeacherScheduleState {
  final List<ScheduleEntity> schedule;
  const TeacherScheduleSuccess(this.schedule);

  @override
  List<Object> get props => [schedule];
}

class TeacherScheduleFailure extends TeacherScheduleState {
  final String message;
  const TeacherScheduleFailure(this.message);

  @override
  List<Object> get props => [message];
}
