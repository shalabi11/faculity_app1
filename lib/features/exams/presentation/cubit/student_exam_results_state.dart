// lib/features/exams/presentation/cubit/student_exam_results_state.dart
part of 'student_exam_results_cubit.dart';

abstract class StudentExamResultsState {}

class StudentExamResultsInitial extends StudentExamResultsState {}

class StudentExamResultsLoading extends StudentExamResultsState {}

class StudentExamResultsSuccess extends StudentExamResultsState {
  final List<ExamResult> results;
  StudentExamResultsSuccess(this.results);
}

class StudentExamResultsFailure extends StudentExamResultsState {
  final String message;
  StudentExamResultsFailure(this.message);
}
