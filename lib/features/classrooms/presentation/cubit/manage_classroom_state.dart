part of 'manage_classroom_cubit.dart';

abstract class ManageClassroomState {}

class ManageClassroomInitial extends ManageClassroomState {}

class ManageClassroomLoading extends ManageClassroomState {}

class ManageClassroomSuccess extends ManageClassroomState {
  final String message;
  ManageClassroomSuccess(this.message);
}

class ManageClassroomFailure extends ManageClassroomState {
  final String message;
  ManageClassroomFailure(this.message);
}
