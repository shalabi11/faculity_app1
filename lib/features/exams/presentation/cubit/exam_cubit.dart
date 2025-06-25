// lib/features/exams/presentation/cubit/exam_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamsRepository examsRepository;

  // --- تم حذف البارامتر الإضافي "repository" من هنا ---
  ExamCubit({required this.examsRepository}) : super(ExamInitial());

  Future<void> fetchExams() async {
    try {
      emit(ExamLoading());
      final exams = await examsRepository.getExams();
      emit(ExamSuccess(exams));
    } on Exception catch (e) {
      emit(ExamFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
