import 'package:equatable/equatable.dart';

class ScheduleEntity extends Equatable {
  final int id;
  final String courseName;
  final String teacherName;
  final String classroomName;
  final String day;
  final String startTime;
  final String endTime;
  final String type;
  final String year;
  final String? group;

  const ScheduleEntity({
    required this.id,
    required this.courseName,
    required this.teacherName,
    required this.classroomName,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.year,
    this.group,
  });

  @override
  // هذه القائمة تخبر Equatable أي الحقول يجب مقارنتها
  List<Object?> get props => [
    id,
    courseName,
    teacherName,
    classroomName,
    day,
    startTime,
    endTime,
    type,
    year,
    group,
  ];
}
