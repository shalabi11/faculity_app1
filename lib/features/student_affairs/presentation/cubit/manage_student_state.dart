// lib/features/student_affairs/presentation/cubit/manage_student_state.dart

part of 'manage_student_cubit.dart';

abstract class ManageStudentState extends Equatable {
  const ManageStudentState();

  @override
  List<Object> get props => [];
}

class ManageStudentInitial extends ManageStudentState {}

class ManageStudentLoading extends ManageStudentState {}

class ManageStudentSuccess extends ManageStudentState {
  final String message;
  const ManageStudentSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class ManageStudentFailure extends ManageStudentState {
  final String message;
  const ManageStudentFailure(this.message);

  @override
  List<Object> get props => [message];
}
