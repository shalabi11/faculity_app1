part of 'head_of_exams_dashboard_cubit.dart';

// كلاس مساعد لتخزين إحصائيات كل سنة
class YearExamStats extends Equatable {
  final int totalExams;
  final int publishableExams;

  const YearExamStats({
    required this.totalExams,
    required this.publishableExams,
  });

  @override
  List<Object> get props => [totalExams, publishableExams];
}

abstract class HeadOfExamsDashboardState extends Equatable {
  const HeadOfExamsDashboardState();
  @override
  List<Object> get props => [];
}

class HeadOfExamsDashboardInitial extends HeadOfExamsDashboardState {}

class HeadOfExamsDashboardLoading extends HeadOfExamsDashboardState {}

class HeadOfExamsDashboardSuccess extends HeadOfExamsDashboardState {
  // قائمة الامتحانات الجاهزة للنشر (للعرض في القائمة)
  final List<ExamEntity> publishableExams;
  // خريطة تحتوي على إحصائيات كل سنة للمخطط البياني
  final Map<String, YearExamStats> statsByYear;

  const HeadOfExamsDashboardSuccess({
    required this.publishableExams,
    required this.statsByYear,
  });

  @override
  List<Object> get props => [publishableExams, statsByYear];
}

class HeadOfExamsDashboardFailure extends HeadOfExamsDashboardState {
  final String message;
  const HeadOfExamsDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
