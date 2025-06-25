import 'package:faculity_app2/features/courses/domain/entities/course.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseSuccess extends CourseState {
  final List<Course> courses;
  CourseSuccess(this.courses);
}

class CourseFailure extends CourseState {
  final String message;
  CourseFailure(this.message);
}
