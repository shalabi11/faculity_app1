// lib/features/exams/presentation/cubit/student_exam_results_state.dart

import 'package:equatable/equatable.dart';
// تأكد من أن هذا هو المسار الصحيح لكلاس ExamResult
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

abstract class StudentExamResultsState extends Equatable {
  const StudentExamResultsState();

  @override
  List<Object> get props => [];
}

class StudentExamResultsInitial extends StudentExamResultsState {}

// **الحالة التي كانت مفقودة على الأغلب**
class StudentExamResultsLoading extends StudentExamResultsState {}

class StudentExamResultsSuccess extends StudentExamResultsState {
  final List<ExamResult> results;

  const StudentExamResultsSuccess(this.results);

  @override
  List<Object> get props => [results];
}

class StudentExamResultsFailure extends StudentExamResultsState {
  final String message;

  const StudentExamResultsFailure(this.message);

  @override
  List<Object> get props => [message];
}
