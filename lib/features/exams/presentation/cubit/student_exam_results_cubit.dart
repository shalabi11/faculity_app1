// lib/features/exams/presentation/cubit/student_exam_results_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';

class StudentExamResultsCubit extends Cubit<StudentExamResultsState> {
  final ExamRepository examsRepository;
  StudentExamResultsCubit({required this.examsRepository})
    : super(StudentExamResultsInitial());

  Future<void> fetchStudentResults({required int studentId}) async {
    try {
      emit(StudentExamResultsLoading());
      // ✨ --- تم التعديل هنا لاستدعاء الدالة الصحيحة --- ✨
      final resultsOrFailure = await examsRepository.getStudentResults(
        studentId,
      );

      resultsOrFailure.fold(
        (failure) => emit(StudentExamResultsFailure(failure.toString())),
        (results) => emit(StudentExamResultsSuccess(results)),
      );
    } on Exception catch (e) {
      emit(
        StudentExamResultsFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
