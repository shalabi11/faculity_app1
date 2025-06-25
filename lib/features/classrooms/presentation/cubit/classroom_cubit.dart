import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';
import 'package:faculity_app2/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  final ClassroomRepository classroomRepository;
  ClassroomCubit({required this.classroomRepository})
    : super(ClassroomInitial());

  Future<void> fetchClassrooms() async {
    try {
      emit(ClassroomLoading());
      final classrooms = await classroomRepository.getClassrooms();
      emit(ClassroomSuccess(classrooms));
    } on Exception catch (e) {
      emit(ClassroomFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
