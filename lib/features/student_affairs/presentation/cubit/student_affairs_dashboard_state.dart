part of 'student_affairs_dashboard_cubit.dart';

abstract class StudentAffairsDashboardState extends Equatable {
  const StudentAffairsDashboardState();
  @override
  List<Object> get props => [];
}

class StudentAffairsDashboardInitial extends StudentAffairsDashboardState {}

class StudentAffairsDashboardLoading extends StudentAffairsDashboardState {}

class StudentAffairsDashboardSuccess extends StudentAffairsDashboardState {
  final Map<String, List<Student>> studentsByYear;

  // ✨ تم حذف pendingStudentsCount من هنا
  const StudentAffairsDashboardSuccess({required this.studentsByYear});

  int get totalStudents =>
      studentsByYear.values.fold(0, (sum, list) => sum + list.length);

  @override
  List<Object> get props => [studentsByYear];
}

class StudentAffairsDashboardFailure extends StudentAffairsDashboardState {
  final String message;
  const StudentAffairsDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
