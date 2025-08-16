// lib/features/schedule/data/models/schedule_entry_model.dart

import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

class ScheduleEntryModel extends ScheduleEntity {
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
    return ScheduleEntryModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      courseName: json['course_name'] ?? 'مادة غير معروفة',
      teacherName: json['teacher_name'] ?? 'مدرس غير معروف',
      classroomName: json['classroom_name'] ?? 'قاعة غير معروفة',
      day: json['day'] ?? 'يوم غير محدد',
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      type: json['type'] ?? 'نوع غير محدد', // إذا عندك نوع بالـ API
      year: json['year'] ?? 'سنة غير محددة',
      group: json['group'],
    );
  }
}
