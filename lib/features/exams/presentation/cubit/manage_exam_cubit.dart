import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
part 'manage_exam_state.dart';

class ManageExamCubit extends Cubit<ManageExamState> {
  final ExamRepository examsRepository;
  ManageExamCubit({required this.examsRepository}) : super(ManageExamInitial());

  Future<void> addExam({required Map<String, dynamic> examData}) async {
    emit(ManageExamLoading());
    final result = await examsRepository.addExam(examData: examData);
    result.fold(
      (failure) => emit(ManageExamFailure(failure.toString())),
      (_) => emit(ManageExamSuccess('تم إضافة الامتحان بنجاح!')),
    );
  }

  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    emit(ManageExamLoading());
    final result = await examsRepository.updateExam(id: id, examData: examData);
    result.fold(
      (failure) => emit(ManageExamFailure(failure.toString())),
      (_) => emit(ManageExamSuccess('تم تعديل الامتحان بنجاح!')),
    );
  }

  Future<void> deleteExam({required int id}) async {
    emit(ManageExamLoading());
    final result = await examsRepository.deleteExam(id: id);
    result.fold(
      (failure) => emit(ManageExamFailure(failure.toString())),
      (_) => emit(ManageExamSuccess('تم حذف الامتحان بنجاح!')),
    );
  }
}
