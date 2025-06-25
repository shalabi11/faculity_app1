// lib/features/student/presentation/cubit/student_state.dart

part of 'student_cubit.dart';

abstract class StudentState {}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {
  final List<Student> students;
  StudentSuccess(this.students);
}

class StudentFailure extends StudentState {
  final String message;
  StudentFailure(this.message);
}
