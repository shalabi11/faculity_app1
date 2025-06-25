import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/classrooms/domain/repositories/classroom_repository.dart';
part 'manage_classroom_state.dart';

class ManageClassroomCubit extends Cubit<ManageClassroomState> {
  final ClassroomRepository classroomRepository;
  ManageClassroomCubit({required this.classroomRepository})
    : super(ManageClassroomInitial());

  Future<void> addClassroom({
    required Map<String, dynamic> classroomData,
  }) async {
    try {
      emit(ManageClassroomLoading());
      await classroomRepository.addClassroom(classroomData: classroomData);
      emit(ManageClassroomSuccess('تمت إضافة القاعة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageClassroomFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateClassroom({
    required int id,
    required Map<String, dynamic> classroomData,
  }) async {
    try {
      emit(ManageClassroomLoading());
      await classroomRepository.updateClassroom(
        id: id,
        classroomData: classroomData,
      );
      emit(ManageClassroomSuccess('تم تعديل القاعة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageClassroomFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteClassroom({required int id}) async {
    try {
      emit(ManageClassroomLoading());
      await classroomRepository.deleteClassroom(id: id);
      emit(ManageClassroomSuccess('تم حذف القاعة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageClassroomFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
