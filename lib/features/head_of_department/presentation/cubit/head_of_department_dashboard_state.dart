part of 'head_of_department_dashboard_cubit.dart';

abstract class HeadOfDepartmentDashboardState extends Equatable {
  const HeadOfDepartmentDashboardState();
  @override
  List<Object> get props => [];
}

class HeadOfDepartmentDashboardInitial extends HeadOfDepartmentDashboardState {}

class HeadOfDepartmentDashboardLoading extends HeadOfDepartmentDashboardState {}

class HeadOfDepartmentDashboardSuccess extends HeadOfDepartmentDashboardState {
  // قائمة المدرسين في قسم رئيس القسم
  final List<TeacherEntity> departmentTeachers;
  // قائمة المقررات في قسم رئيس القسم
  final List<CourseEntity> departmentCourses;

  const HeadOfDepartmentDashboardSuccess({
    required this.departmentTeachers,
    required this.departmentCourses,
  });

  @override
  List<Object> get props => [departmentTeachers, departmentCourses];
}

class HeadOfDepartmentDashboardFailure extends HeadOfDepartmentDashboardState {
  final String message;
  const HeadOfDepartmentDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
