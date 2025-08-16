// lib/features/student_affairs/presentation/cubit/student_affairs_state.dart
part of 'student_affairs_cubit.dart';

abstract class StudentAffairsState extends Equatable {
  const StudentAffairsState();

  @override
  List<Object> get props => [];
}

class StudentAffairsInitial extends StudentAffairsState {}

class StudentAffairsLoading extends StudentAffairsState {}

class StudentAffairsLoaded extends StudentAffairsState {
  final List<Student> students;

  const StudentAffairsLoaded({required this.students});

  @override
  List<Object> get props => [students];
}

class StudentAffairsError extends StudentAffairsState {
  final String message;

  const StudentAffairsError({required this.message});

  @override
  List<Object> get props => [message];
}
