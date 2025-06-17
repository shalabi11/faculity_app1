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
    // الوصول الآمن للبيانات المتداخلة
    final courseData = json['course'] as Map<String, dynamic>? ?? {};
    final teacherData = json['teacher'] as Map<String, dynamic>? ?? {};
    final classroomData = json['classroom'] as Map<String, dynamic>? ?? {};

    return ScheduleEntryModel(
      // استخدام '??' لتوفير قيمة افتراضية في حال كانت القيمة null
      id: json['id'] ?? 0,
      courseName: courseData['name'] ?? 'مادة غير محددة',
      teacherName: teacherData['name'] ?? 'مدرس غير محدد',
      classroomName: classroomData['name'] ?? 'قاعة غير محددة',
      day: json['day'] ?? 'يوم غير محدد',
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
    );
  }
}
