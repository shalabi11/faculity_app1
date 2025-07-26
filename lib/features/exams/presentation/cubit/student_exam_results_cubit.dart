// lib/features/exams/presentation/cubit/student_exam_results_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_state.dart';

class StudentExamResultsCubit extends Cubit<StudentExamResultsState> {
  final ExamRepository examsRepository;
  StudentExamResultsCubit({required this.examsRepository})
    : super(StudentExamResultsInitial());

  // هذه هي الدالة التي تستدعي getStudentResults من المستودع
  Future<void> fetchStudentResults({required int studentId}) async {
    try {
      emit(StudentExamResultsLoading());
      final results = await examsRepository.getAllExams(
        // studentId: studentId,
      );
      emit(StudentExamResultsSuccess(results as List<ExamResultEntity>));
    } on Exception catch (e) {
      emit(
        StudentExamResultsFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
