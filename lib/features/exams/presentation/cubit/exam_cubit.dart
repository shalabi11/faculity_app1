import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  final ExamRepository examRepository;

  ExamCubit({required this.examRepository}) : super(ExamInitial());

  Future<void> fetchExams() async {
    emit(ExamLoading());
    final failureOrExams = await examRepository.getAllExams();
    failureOrExams.fold(
      (failure) => emit(ExamError(message: failure.toString())),
      (exams) => emit(ExamLoaded(exams: exams)),
    );
  }
}
