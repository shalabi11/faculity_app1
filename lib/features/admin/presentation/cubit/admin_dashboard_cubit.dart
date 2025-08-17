// lib/features/admin/presentation/cubit/admin_dashboard_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';

part 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final StudentAffairsRepository studentRepository;
  final TeacherRepository teacherRepository;
  final CourseRepository courseRepository;

  AdminDashboardCubit({
    required this.studentRepository,
    required this.teacherRepository,
    required this.courseRepository,
  }) : super(AdminDashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(AdminDashboardLoading());
    try {
      // جلب كل البيانات اللازمة في نفس الوقت
      final results = await Future.wait([
        studentRepository.getStudents(),
        teacherRepository.getTeachers(),
        courseRepository.getAllCourses(),
      ]);

      // ✨ --- هذا هو الجزء الذي تم تعديله بالكامل --- ✨
      // 1. نقوم بعمل Cast آمن للنتائج لتحويلها إلى أنواعها الصحيحة
      final studentsResult = results[0] as Either<Failure, List<Student>>;
      final teachers = results[1] as List<TeacherEntity>;
      final coursesResult = results[2] as Either<Failure, List<CourseEntity>>;

      // 2. معالجة النتائج بشكل متسلسل
      studentsResult.fold(
        (failure) => emit(AdminDashboardFailure(failure.toString())),
        (students) {
          coursesResult.fold(
            (failure) => emit(AdminDashboardFailure(failure.toString())),
            (courses) {
              // تجميع الطلاب حسب السنة
              final Map<String, int> studentsByYear = {};
              for (var student in students) {
                studentsByYear[student.year] =
                    (studentsByYear[student.year] ?? 0) + 1;
              }

              emit(
                AdminDashboardSuccess(
                  studentCount: students.length,
                  teacherCount: teachers.length,
                  courseCount: courses.length,
                  studentsByYear: studentsByYear,
                ),
              );
            },
          );
        },
      );
    } on Exception catch (e) {
      emit(AdminDashboardFailure(e.toString()));
    }
  }
}
