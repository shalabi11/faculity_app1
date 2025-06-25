part of 'manage_course_cubit.dart';

abstract class ManageCourseState {}

class ManageCourseInitial extends ManageCourseState {}

class ManageCourseLoading extends ManageCourseState {}

class ManageCourseSuccess extends ManageCourseState {
  final String message;
  ManageCourseSuccess(this.message);
}

class ManageCourseFailure extends ManageCourseState {
  final String message;
  ManageCourseFailure(this.message);
}
