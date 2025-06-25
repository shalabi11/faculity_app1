// lib/features/schedule/data/models/schedule_entry_model.dart

import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

class ScheduleEntryModel extends ScheduleEntry {
  const ScheduleEntryModel({
    required super.id,
    required super.courseName,
    required super.teacherName,
    required super.classroomName,
    required super.day,
    required super.startTime,
    required super.endTime,
    required super.type,
    required super.year,
    super.group,
  });

  factory ScheduleEntryModel.fromJson(Map<String, dynamic> json) {
    final courseData = json['course'] as Map<String, dynamic>? ?? {};
    final teacherData = json['teacher'] as Map<String, dynamic>? ?? {};
    final classroomData = json['classroom'] as Map<String, dynamic>? ?? {};

    return ScheduleEntryModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      courseName: courseData['name'] ?? 'مادة غير معروفة',
      teacherName: teacherData['full_name'] ?? 'مدرس غير معروف',
      classroomName: classroomData['name'] ?? 'قاعة غير معروفة',
      day: json['day'] ?? 'يوم غير محدد',
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      type: json['type'] ?? 'نوع غير محدد',
      year: json['year'] ?? 'سنة غير محددة',
      group: json['group'],
    );
  }
}
