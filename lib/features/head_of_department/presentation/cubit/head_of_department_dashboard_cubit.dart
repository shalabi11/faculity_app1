import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';

part 'head_of_department_dashboard_state.dart';

class HeadOfDepartmentDashboardCubit
    extends Cubit<HeadOfDepartmentDashboardState> {
  final TeacherRepository teacherRepository;
  final CourseRepository courseRepository;

  HeadOfDepartmentDashboardCubit({
    required this.teacherRepository,
    required this.courseRepository,
  }) : super(HeadOfDepartmentDashboardInitial());

  Future<void> fetchDashboardData(String department) async {
    emit(HeadOfDepartmentDashboardLoading());
    try {
      final results = await Future.wait([
        teacherRepository.getTeachers(),
        courseRepository.getAllCourses(),
      ]);

      // ✨ --- 1. تم تعديل هذا الجزء بالكامل --- ✨
      // نقوم بعمل Cast آمن للنتائج لتحويلها إلى أنواعها الصحيحة
      final teachers = results[0] as List<TeacherEntity>;
      final coursesResult = results[1] as Either<Failure, List<CourseEntity>>;

      coursesResult.fold(
        (failure) => emit(HeadOfDepartmentDashboardFailure(failure.toString())),
        (courses) {
          // تصفية المدرسين والمقررات حسب القسم
          final departmentTeachers =
              teachers.where((t) => t.department == department).toList();
          final departmentCourses =
              courses.where((c) => c.department == department).toList();

          emit(
            HeadOfDepartmentDashboardSuccess(
              departmentTeachers: departmentTeachers,
              departmentCourses: departmentCourses,
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(HeadOfDepartmentDashboardFailure(e.toString()));
    }
  }
}
