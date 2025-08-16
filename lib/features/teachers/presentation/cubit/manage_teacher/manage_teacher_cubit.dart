import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';
part 'manage_teacher_state.dart';

class ManageTeacherCubit extends Cubit<ManageTeacherState> {
  final TeacherRepository teacherRepository;
  ManageTeacherCubit({required this.teacherRepository})
    : super(ManageTeacherInitial());

  Future<void> addTeacher({required Map<String, dynamic> teacherData}) async {
    try {
      emit(ManageTeacherLoading());
      await teacherRepository.addTeacher(teacherData: teacherData);
      emit(ManageTeacherSuccess('تمت إضافة المدرس بنجاح!'));
    } on Exception catch (e) {
      emit(ManageTeacherFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateTeacher({
    required int id,
    required Map<String, dynamic> teacherData,
  }) async {
    try {
      emit(ManageTeacherLoading());
      await teacherRepository.updateTeacher(id: id, teacherData: teacherData);
      emit(ManageTeacherSuccess('تم تعديل بيانات المدرس بنجاح!'));
    } on Exception catch (e) {
      emit(ManageTeacherFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteTeacher({required int id}) async {
    try {
      emit(ManageTeacherLoading());
      await teacherRepository.deleteTeacher(id: id);
      emit(ManageTeacherSuccess('تم حذف المدرس بنجاح!'));
    } on Exception catch (e) {
      emit(ManageTeacherFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
