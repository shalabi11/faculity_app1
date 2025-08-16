// lib/features/teachers/presentation/cubit/teacher_job/teacher_courses_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_job/teacher_courses_state.dart';

class TeacherCoursesCubit extends Cubit<TeacherCoursesState> {
  final ScheduleRepository scheduleRepository;
  final CourseRepository courseRepository;

  TeacherCoursesCubit({
    required this.scheduleRepository,
    required this.courseRepository,
  }) : super(TeacherCoursesInitial());

  Future<void> fetchTeacherCourses(String teacherName) async {
    emit(TeacherCoursesLoading());
    try {
      // 1. جلب كل الجداول المتاحة (نظري وعملي)
      const years = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة'];
      const groups = ['A', 'B'];
      const sections = ['A', 'B'];
      List<ScheduleEntity> allSchedules = [];

      for (var year in years) {
        final theoryResult = await scheduleRepository.getTheorySchedule(year);
        theoryResult.fold((l) => null, (r) => allSchedules.addAll(r));
      }
      for (var group in groups) {
        for (var section in sections) {
          final labResult = await scheduleRepository.getLabSchedule(
            group,
            section,
          );
          labResult.fold((l) => null, (r) => allSchedules.addAll(r));
        }
      }

      // 2. استخلاص أسماء المقررات الفريدة التي يدرسها الدكتور
      final courseNames =
          allSchedules
              .where((entry) => entry.teacherName == teacherName)
              .map((entry) => entry.courseName)
              .toSet();

      if (courseNames.isEmpty) {
        emit(const TeacherCoursesSuccess([]));
        return;
      }

      // 3. جلب كل المقررات في الكلية
      final allCoursesResult = await courseRepository.getAllCourses();

      allCoursesResult.fold(
        (failure) => emit(TeacherCoursesFailure(failure.toString())),
        (allCourses) {
          // 4. تصفية قائمة المقرات الكلية لمطابقة أسماء مقررات الدكتور
          final teacherCourses =
              allCourses
                  .where((course) => courseNames.contains(course.name))
                  .toList();
          emit(TeacherCoursesSuccess(teacherCourses));
        },
      );
    } on Exception catch (e) {
      emit(TeacherCoursesFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
