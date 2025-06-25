// lib/features/exams/presentation/cubit/exam_state.dart
part of 'exam_cubit.dart';

abstract class ExamState {}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamSuccess extends ExamState {
  final List<Exam> exams;
  ExamSuccess(this.exams);
}

class ExamFailure extends ExamState {
  final String message;
  ExamFailure(this.message);
}
