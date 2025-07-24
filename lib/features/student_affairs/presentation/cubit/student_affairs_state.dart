part of 'student_affairs_cubit.dart';

abstract class StudentAffairsState extends Equatable {
  const StudentAffairsState();

  @override
  List<Object> get props => [];
}

class StudentAffairsInitial extends StudentAffairsState {}

class StudentAffairsLoading extends StudentAffairsState {}

class StudentAffairsLoaded extends StudentAffairsState {
  // هذا هو الحقل الصحيح الذي يحتوي على بيانات لوحة التحكم
  final StudentDashboardEntity dashboardData;

  // --- هذا هو التعريف الصحيح للـ constructor ---
  // قمنا بحذف البارامتر الزائد والخاطئ (dashboardEntity)
  const StudentAffairsLoaded({required this.dashboardData});

  @override
  List<Object> get props => [dashboardData];
}

class StudentAffairsError extends StudentAffairsState {
  final String message;

  const StudentAffairsError({required this.message});

  @override
  List<Object> get props => [message];
}
