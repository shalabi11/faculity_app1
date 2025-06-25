import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
part 'manage_course_state.dart';

class ManageCourseCubit extends Cubit<ManageCourseState> {
  final CourseRepository courseRepository;
  ManageCourseCubit({required this.courseRepository})
    : super(ManageCourseInitial());

  Future<void> addCourse({required Map<String, dynamic> courseData}) async {
    try {
      emit(ManageCourseLoading());
      await courseRepository.addCourse(courseData: courseData);
      emit(ManageCourseSuccess('تمت إضافة المادة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageCourseFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  }) async {
    try {
      emit(ManageCourseLoading());
      await courseRepository.updateCourse(id: id, courseData: courseData);
      emit(ManageCourseSuccess('تم تعديل المادة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageCourseFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteCourse({required int id}) async {
    try {
      emit(ManageCourseLoading());
      await courseRepository.deleteCourse(id: id);
      emit(ManageCourseSuccess('تم حذف المادة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageCourseFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
