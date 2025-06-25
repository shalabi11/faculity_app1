import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';

abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherSuccess extends TeacherState {
  final List<Teacher> teachers;
  TeacherSuccess(this.teachers);
}

class TeacherFailure extends TeacherState {
  final String message;
  TeacherFailure(this.message);
}
