import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';

part 'teacher_dashboard_state.dart';

class TeacherDashboardCubit extends Cubit<TeacherDashboardState> {
  final ScheduleRepository scheduleRepository;
  final CourseRepository courseRepository;
  final ExamRepository examRepository;

  TeacherDashboardCubit({
    required this.scheduleRepository,
    required this.courseRepository,
    required this.examRepository,
  }) : super(TeacherDashboardInitial());

  Future<void> fetchDashboardData(String teacherName) async {
    emit(TeacherDashboardLoading());
    try {
      // جلب كل البيانات اللازمة
      final schedule = await _fetchFullSchedule(teacherName);
      final courses = await _fetchTeacherCourses(schedule);
      final upcomingExam = await _fetchUpcomingExam(courses);

      emit(
        TeacherDashboardSuccess(
          schedule: schedule,
          courses: courses,
          upcomingExam: upcomingExam,
        ),
      );
    } on Exception catch (e) {
      emit(TeacherDashboardFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<List<ScheduleEntity>> _fetchFullSchedule(String teacherName) async {
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
    return allSchedules
        .where((s) => s.teacherName == teacherName)
        .toSet()
        .toList();
  }

  Future<List<CourseEntity>> _fetchTeacherCourses(
    List<ScheduleEntity> schedule,
  ) async {
    final courseNames = schedule.map((s) => s.courseName).toSet();
    if (courseNames.isEmpty) return [];

    final allCoursesResult = await courseRepository.getAllCourses();
    return allCoursesResult.fold(
      (l) => [],
      (allCourses) =>
          allCourses.where((c) => courseNames.contains(c.name)).toList(),
    );
  }

  Future<ExamEntity?> _fetchUpcomingExam(
    List<CourseEntity> teacherCourses,
  ) async {
    if (teacherCourses.isEmpty) return null;

    final teacherCourseIds = teacherCourses.map((c) => c.id).toSet();
    final allExamsResult = await examRepository.getAllExams();

    return allExamsResult.fold((l) => null, (allExams) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final upcomingExams =
          allExams.where((exam) {
            final isForTeacher = teacherCourseIds.contains(exam.courseId);
            if (!isForTeacher) return false;
            try {
              return !DateTime.parse(exam.examDate).isBefore(today);
            } catch (e) {
              return false;
            }
          }).toList();

      if (upcomingExams.isEmpty) return null;

      upcomingExams.sort(
        (a, b) =>
            DateTime.parse(a.examDate).compareTo(DateTime.parse(b.examDate)),
      );
      return upcomingExams.first;
    });
  }
}
