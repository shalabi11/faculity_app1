// lib/features/teachers/presentation/cubit/teacher_job/teacher_courses_state.dart

import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';

abstract class TeacherCoursesState extends Equatable {
  const TeacherCoursesState();

  @override
  List<Object> get props => [];
}

class TeacherCoursesInitial extends TeacherCoursesState {}

class TeacherCoursesLoading extends TeacherCoursesState {}

class TeacherCoursesSuccess extends TeacherCoursesState {
  final List<CourseEntity> courses;
  const TeacherCoursesSuccess(this.courses);

  @override
  List<Object> get props => [courses];
}

class TeacherCoursesFailure extends TeacherCoursesState {
  final String message;
  const TeacherCoursesFailure(this.message);

  @override
  List<Object> get props => [message];
}
