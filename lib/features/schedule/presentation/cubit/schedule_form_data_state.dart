import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
// لاحقاً سنقوم بإنشاء هذا الكيان
// import 'package:faculity_app2/features/classrooms/domain/entities/classroom_entity.dart';

abstract class ScheduleFormDataState extends Equatable {
  const ScheduleFormDataState();
  @override
  List<Object> get props => [];
}

class ScheduleFormDataInitial extends ScheduleFormDataState {}

class ScheduleFormDataLoading extends ScheduleFormDataState {}

class ScheduleFormDataLoaded extends ScheduleFormDataState {
  final List<CourseEntity> courses;
  final List<TeacherEntity> teachers;
  // final List<ClassroomEntity> classrooms;

  const ScheduleFormDataLoaded({
    required this.courses,
    required this.teachers,
    // required this.classrooms,
  });

  @override
  List<Object> get props => [courses, teachers];
}

class ScheduleFormDataFailure extends ScheduleFormDataState {
  final String message;
  const ScheduleFormDataFailure(this.message);
  @override
  List<Object> get props => [message];
}
