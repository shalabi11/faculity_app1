import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherRepository teacherRepository;
  TeacherCubit({required this.teacherRepository}) : super(TeacherInitial());

  Future<void> fetchTeachers() async {
    try {
      emit(TeacherLoading());
      final teachers = await teacherRepository.getTeachers();
      emit(TeacherSuccess(teachers));
    } on Exception catch (e) {
      emit(TeacherFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
