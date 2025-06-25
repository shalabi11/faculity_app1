import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_state.dart';

class ExamHallAssignmentCubit extends Cubit<ExamHallAssignmentState> {
  final ExamHallAssignmentRepository repository;

  ExamHallAssignmentCubit({required this.repository})
    : super(ExamHallAssignmentInitial());

  Future<void> distributeHalls({required int examId}) async {
    try {
      emit(ExamHallAssignmentLoading());
      await repository.distributeHalls(examId: examId);
      emit(ExamHallAssignmentDistributionSuccess());
    } on Exception catch (e) {
      emit(
        ExamHallAssignmentFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }

  Future<void> getAssignments({required int examId}) async {
    try {
      emit(ExamHallAssignmentLoading());
      final assignments = await repository.getHallAssignments(examId: examId);
      emit(ExamHallAssignmentLoadSuccess(assignments));
    } on Exception catch (e) {
      emit(
        ExamHallAssignmentFailure(e.toString().replaceAll('Exception: ', '')),
      );
    }
  }
}
