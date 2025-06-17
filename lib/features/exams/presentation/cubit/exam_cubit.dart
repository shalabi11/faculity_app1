import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';

class ExamsCubit extends Cubit<ExamsState> {
  final ExamsRepository repository;

  ExamsCubit({required this.repository}) : super(const ExamsState());

  Future<void> fetchExams() async {
    try {
      emit(state.copyWith(examsStatus: ExamsStatus.loading));
      final exams = await repository.getExams();
      emit(state.copyWith(examsStatus: ExamsStatus.loaded, exams: exams));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          examsStatus: ExamsStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> fetchStudentResults(int studentId) async {
    try {
      emit(state.copyWith(resultsStatus: ExamsStatus.loading));
      final results = await repository.getStudentResults(studentId);
      emit(state.copyWith(resultsStatus: ExamsStatus.loaded, results: results));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          resultsStatus: ExamsStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
