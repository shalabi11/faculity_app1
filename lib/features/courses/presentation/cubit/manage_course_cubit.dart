import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:equatable/equatable.dart';

part 'manage_course_state.dart';

class ManageCourseCubit extends Cubit<ManageCourseState> {
  final CourseRepository courseRepository;
  ManageCourseCubit({required this.courseRepository})
    : super(ManageCourseInitial());

  Future<void> addCourse({required Map<String, dynamic> courseData}) async {
    emit(ManageCourseLoading());
    final result = await courseRepository.addCourse(courseData);
    result.fold(
      (failure) => emit(ManageCourseFailure(failure.toString())),
      (_) => emit(ManageCourseSuccess('تمت إضافة المادة بنجاح!')),
    );
  }

  // دوال التعديل والحذف ستكون بنفس الطريقة
  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  }) async {
    emit(ManageCourseLoading());
    final result = await courseRepository.updateCourse(id, courseData);
    result.fold(
      (failure) => emit(ManageCourseFailure(failure.toString())),
      (_) => emit(ManageCourseSuccess('تم تعديل المادة بنجاح!')),
    );
  }

  Future<void> deleteCourse({required int id}) async {
    emit(ManageCourseLoading());
    final result = await courseRepository.deleteCourse(id);
    result.fold(
      (failure) => emit(ManageCourseFailure(failure.toString())),
      (_) => emit(ManageCourseSuccess('تم حذف المادة بنجاح!')),
    );
  }
}
