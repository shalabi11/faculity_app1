part of 'manage_teacher_cubit.dart';

abstract class ManageTeacherState {}

class ManageTeacherInitial extends ManageTeacherState {}

class ManageTeacherLoading extends ManageTeacherState {}

class ManageTeacherSuccess extends ManageTeacherState {
  final String message;
  ManageTeacherSuccess(this.message);
}

class ManageTeacherFailure extends ManageTeacherState {
  final String message;
  ManageTeacherFailure(this.message);
}
