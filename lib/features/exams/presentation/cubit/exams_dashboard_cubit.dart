import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';

part 'exams_dashboard_state.dart';

class ExamsDashboardCubit extends Cubit<ExamsDashboardState> {
  final ExamRepository examRepository;
  final CourseRepository courseRepository;

  ExamsDashboardCubit({
    required this.examRepository,
    required this.courseRepository,
  }) : super(ExamsDashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(ExamsDashboardLoading());
    try {
      final results = await Future.wait([
        examRepository.getAllExams(),
        courseRepository.getAllCourses(),
      ]);

      final examsResult = results[0] as Either<Failure, List<ExamEntity>>;
      final coursesResult = results[1] as Either<Failure, List<CourseEntity>>;

      examsResult.fold(
        (examFailure) => emit(ExamsDashboardFailure(examFailure.toString())),
        (exams) {
          coursesResult.fold(
            (courseFailure) =>
                emit(ExamsDashboardFailure(courseFailure.toString())),
            (courses) {
              // ✨ --- 1. التعديل الرئيسي هنا --- ✨
              // بدلاً من الاعتماد على ID، سنعتمد على اسم المادة
              final scheduledCourseNames =
                  exams.map((e) => e.courseName).toSet();

              // ✨ --- 2. تعديل منطق الفلترة --- ✨
              // الآن نقوم بتصفية المواد التي لا يوجد اسمها في قائمة أسماء الامتحانات المجدولة
              final List<CourseEntity> unscheduled =
                  courses
                      .where((c) => !scheduledCourseNames.contains(c.name))
                      .toList();

              final List<ExamEntity> scheduled = [...exams];

              scheduled.sort(
                (a, b) => DateTime.parse(
                  b.examDate,
                ).compareTo(DateTime.parse(a.examDate)),
              );

              emit(
                ExamsDashboardSuccess(
                  scheduledExams: scheduled,
                  unscheduledCourses: unscheduled,
                ),
              );
            },
          );
        },
      );
    } on Exception catch (e) {
      emit(ExamsDashboardFailure(e.toString()));
    }
  }
}
