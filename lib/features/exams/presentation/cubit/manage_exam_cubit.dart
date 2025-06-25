import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
part 'manage_exam_state.dart';

class ManageExamCubit extends Cubit<ManageExamState> {
  final ExamsRepository examsRepository;
  ManageExamCubit({required this.examsRepository}) : super(ManageExamInitial());

  Future<void> addExam({required Map<String, dynamic> examData}) async {
    try {
      emit(ManageExamLoading());
      await examsRepository.addExam(examData: examData);
      emit(ManageExamSuccess('تمت إضافة الامتحان بنجاح!'));
    } on Exception catch (e) {
      emit(ManageExamFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    try {
      emit(ManageExamLoading());
      await examsRepository.updateExam(id: id, examData: examData);
      emit(ManageExamSuccess('تم تعديل الامتحان بنجاح!'));
    } on Exception catch (e) {
      emit(ManageExamFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteExam({required int id}) async {
    try {
      emit(ManageExamLoading());
      await examsRepository.deleteExam(id: id);
      emit(ManageExamSuccess('تم حذف الامتحان بنجاح!'));
    } on Exception catch (e) {
      emit(ManageExamFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
