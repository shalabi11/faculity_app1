// lib/features/student_affairs/presentation/cubit/student_affairs_dashboard_state.dart

import 'package:equatable/equatable.dart';

abstract class StudentAffairsDashboardState extends Equatable {
  const StudentAffairsDashboardState();
  @override
  List<Object> get props => [];
}

class StudentAffairsDashboardInitial extends StudentAffairsDashboardState {}

class StudentAffairsDashboardLoading extends StudentAffairsDashboardState {}

class StudentAffairsDashboardSuccess extends StudentAffairsDashboardState {
  // ✨ --- 1. تم التعديل هنا --- ✨
  // الآن يحتوي فقط على العدد الإجمالي للطلاب
  final int totalStudents;

  const StudentAffairsDashboardSuccess({required this.totalStudents});

  @override
  List<Object> get props => [totalStudents];
}

class StudentAffairsDashboardFailure extends StudentAffairsDashboardState {
  final String message;
  const StudentAffairsDashboardFailure(this.message);
  @override
  List<Object> get props => [message];
}
