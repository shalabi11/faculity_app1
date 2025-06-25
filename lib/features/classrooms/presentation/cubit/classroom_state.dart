import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';

abstract class ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomSuccess extends ClassroomState {
  final List<Classroom> classrooms;
  ClassroomSuccess(this.classrooms);
}

class ClassroomFailure extends ClassroomState {
  final String message;
  ClassroomFailure(this.message);
}
