import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_form_data_state.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';

class ScheduleFormDataCubit extends Cubit<ScheduleFormDataState> {
  final CourseRepository courseRepository;
  final TeacherRepository teacherRepository;

  ScheduleFormDataCubit({
    required this.courseRepository,
    required this.teacherRepository,
  }) : super(ScheduleFormDataInitial());

  Future<void> fetchFormData() async {
    emit(ScheduleFormDataLoading());
    try {
      final results = await Future.wait([
        courseRepository.getAllCourses(),
        teacherRepository.getTeachers(),
      ]);

      // --- هذا هو الجزء الذي تم تصحيحه ---
      // 1. تحويل أنواع البيانات بشكل آمن
      final coursesResult = results[0] as Either<Failure, List<CourseEntity>>;
      final teachers = results[1] as List<TeacherEntity>;

      // 2. معالجة نتيجة المقررات باستخدام fold
      final courses = coursesResult.fold(
        (failure) =>
            throw Exception(
              failure.toString(),
            ), // إذا فشل، أرمِ خطأً ليتم التقاطه في catch
        (courseList) => courseList, // إذا نجح، أرجع القائمة
      );

      emit(ScheduleFormDataLoaded(courses: courses, teachers: teachers));
    } catch (e) {
      emit(
        ScheduleFormDataFailure('فشل في جلب بيانات النموذج: ${e.toString()}'),
      );
    }
  }
}
