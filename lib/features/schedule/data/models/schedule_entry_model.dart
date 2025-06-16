// lib/features/schedule/data/models/schedule_entry_model.dart
import '../../domain/entities/schedule_entry.dart';

class ScheduleEntryModel extends ScheduleEntry {
  ScheduleEntryModel({
    required int id,
    required String courseName,
    required String teacherName,
    required String classroomName,
    required String day,
    required String startTime,
    required String endTime,
  }) : super(
         id: id,
         courseName: courseName,
         teacherName: teacherName,
         classroomName: classroomName,
         day: day,
         startTime: startTime,
         endTime: endTime,
       );

  factory ScheduleEntryModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEntryModel(
      id: json['id'],
      courseName: json['course']['name'],
      teacherName: json['teacher']['name'],
      classroomName: json['classroom']['name'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
