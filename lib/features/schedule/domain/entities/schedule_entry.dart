// lib/features/schedule/domain/entities/schedule_entry.dart
class ScheduleEntry {
  final int id;
  final String courseName;
  final String teacherName;
  final String classroomName;
  final String day;
  final String startTime;
  final String endTime;

  ScheduleEntry({
    required this.id,
    required this.courseName,
    required this.teacherName,
    required this.classroomName,
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}
