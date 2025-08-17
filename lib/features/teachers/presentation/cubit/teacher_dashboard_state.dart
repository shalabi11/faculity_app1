part of 'teacher_dashboard_cubit.dart';

abstract class TeacherDashboardState extends Equatable {
  const TeacherDashboardState();
  @override
  List<Object?> get props => [];
}

class TeacherDashboardInitial extends TeacherDashboardState {}

class TeacherDashboardLoading extends TeacherDashboardState {}

class TeacherDashboardSuccess extends TeacherDashboardState {
  // جدول محاضرات الدكتور الكامل
  final List<ScheduleEntity> schedule;
  // قائمة المقررات التي يدرسها
  final List<CourseEntity> courses;
  // الامتحان القادم لأحد مقررات الدكتور
  final ExamEntity? upcomingExam;

  const TeacherDashboardSuccess({
    required this.schedule,
    required this.courses,
    this.upcomingExam,
  });

  @override
  List<Object?> get props => [schedule, courses, upcomingExam];
}

class TeacherDashboardFailure extends TeacherDashboardState {
  final String message;
  const TeacherDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
