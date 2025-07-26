import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/grade_entry_state.dart';

class GradeEntryCubit extends Cubit<GradeEntryState> {
  final ExamRepository examRepository;

  GradeEntryCubit({required this.examRepository}) : super(GradeEntryInitial());

  Future<void> fetchStudentsForExam(int examId) async {
    emit(GradeEntryLoading());
    final result = await examRepository.getStudentsForExam(examId);
    result.fold(
      (failure) => emit(GradeEntryFailure(failure.toString())),
      (students) => emit(GradeEntryLoaded(students)),
    );
  }

  Future<void> saveGrades(List<Map<String, dynamic>> grades) async {
    emit(GradeSaving());
    final result = await examRepository.saveGrades(grades);
    result.fold(
      (failure) => emit(GradeEntryFailure(failure.toString())),
      (_) => emit(GradeSaveSuccess()),
    );
  }
}
