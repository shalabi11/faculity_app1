import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/courses/domain/entities/course.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;
  CourseCubit({required this.courseRepository}) : super(CourseInitial());

  Future<void> fetchCourses() async {
    try {
      emit(CourseLoading());
      final courses = await courseRepository.getCourses();
      emit(CourseSuccess(courses));
    } on Exception catch (e) {
      emit(CourseFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
