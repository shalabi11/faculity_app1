// lib/features/student_affairs/presentation/cubit/all_students_state.dart

part of 'all_students_cubit.dart';

abstract class AllStudentsState extends Equatable {
  const AllStudentsState();
  @override
  List<Object> get props => [];
}

class AllStudentsInitial extends AllStudentsState {}

class AllStudentsLoading extends AllStudentsState {}

class AllStudentsSuccess extends AllStudentsState {
  final List<Student> students;
  const AllStudentsSuccess(this.students);
  @override
  List<Object> get props => [students];
}

class AllStudentsFailure extends AllStudentsState {
  final String message;
  const AllStudentsFailure(this.message);
  @override
  List<Object> get props => [message];
}
