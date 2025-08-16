part of 'exams_dashboard_cubit.dart';

abstract class ExamsDashboardState extends Equatable {
  const ExamsDashboardState();
  @override
  List<Object> get props => [];
}

class ExamsDashboardInitial extends ExamsDashboardState {}

class ExamsDashboardLoading extends ExamsDashboardState {}

class ExamsDashboardSuccess extends ExamsDashboardState {
  // قائمة بالامتحانات المجدولة
  final List<ExamEntity> scheduledExams;
  // قائمة بالمواد التي لم يحدد لها امتحان بعد
  final List<CourseEntity> unscheduledCourses;

  const ExamsDashboardSuccess({
    required this.scheduledExams,
    required this.unscheduledCourses,
  });

  @override
  List<Object> get props => [scheduledExams, unscheduledCourses];
}

class ExamsDashboardFailure extends ExamsDashboardState {
  final String message;
  const ExamsDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
