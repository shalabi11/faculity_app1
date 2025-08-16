// lib/features/teachers/presentation/cubit/teacher_job/teacher_profile_state.dart

part of 'teacher_profile_cubit.dart';

abstract class TeacherProfileState extends Equatable {
  const TeacherProfileState();

  @override
  List<Object> get props => [];
}

class TeacherProfileInitial extends TeacherProfileState {}

class TeacherProfileLoading extends TeacherProfileState {}

class TeacherProfileSuccess extends TeacherProfileState {
  final TeacherEntity teacher;
  const TeacherProfileSuccess(this.teacher);

  @override
  List<Object> get props => [teacher];
}

class TeacherProfileFailure extends TeacherProfileState {
  final String message;
  const TeacherProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}
