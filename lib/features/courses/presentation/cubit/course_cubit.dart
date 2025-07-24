import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;

  CourseCubit({required this.courseRepository}) : super(CourseInitial());

  Future<void> fetchCourses() async {
    emit(CourseLoading());
    final failureOrCourses = await courseRepository.getAllCourses();
    failureOrCourses.fold(
      (failure) => emit(CourseError(message: failure.toString())),
      (courses) => emit(CourseLoaded(courses: courses)),
    );
  }
}
