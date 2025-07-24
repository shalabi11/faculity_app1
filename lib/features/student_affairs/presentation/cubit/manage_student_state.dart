part of 'manage_student_cubit.dart';

abstract class AddStudentState extends Equatable {
  const AddStudentState();

  @override
  List<Object> get props => [];
}

class AddStudentInitial extends AddStudentState {}

class AddStudentLoading extends AddStudentState {}

class AddStudentSuccess extends AddStudentState {}

class AddStudentError extends AddStudentState {
  final String message;
  const AddStudentError({required this.message});

  @override
  List<Object> get props => [message];
}
