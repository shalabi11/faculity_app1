import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_distribution_state.dart';

class ExamDistributionCubit extends Cubit<ExamDistributionState> {
  final ExamRepository examRepository;

  ExamDistributionCubit({required this.examRepository})
    : super(ExamDistributionInitial());

  Future<void> distributeHalls(int examId) async {
    emit(ExamDistributionLoading());
    final result = await examRepository.distributeHalls(examId);
    result.fold(
      (failure) => emit(ExamDistributionFailure(failure.toString())),
      (distributionResults) =>
          emit(ExamDistributionSuccess(distributionResults)),
    );
  }
}
