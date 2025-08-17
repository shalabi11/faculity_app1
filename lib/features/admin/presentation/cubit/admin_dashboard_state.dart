part of 'admin_dashboard_cubit.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();
  @override
  List<Object> get props => [];
}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardSuccess extends AdminDashboardState {
  final int studentCount;
  final int teacherCount;
  final int courseCount;
  // خريطة لتخزين عدد الطلاب في كل سنة للمخطط البياني
  final Map<String, int> studentsByYear;

  const AdminDashboardSuccess({
    required this.studentCount,
    required this.teacherCount,
    required this.courseCount,
    required this.studentsByYear,
  });

  @override
  List<Object> get props => [
    studentCount,
    teacherCount,
    courseCount,
    studentsByYear,
  ];
}

class AdminDashboardFailure extends AdminDashboardState {
  final String message;
  const AdminDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
