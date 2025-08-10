import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

class ExamModel extends ExamEntity {
  const ExamModel({
    required super.id,

    required super.courseName,
    required super.examDate,
    required super.startTime,
    required super.endTime,
    required super.type,
    required super.courseId,
    super.targetYear,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      // 1. التحويل الآمن للـ ID، مع قيمة افتراضية في حالة كان فارغاً
      id: int.tryParse(json['id'].toString()) ?? 0,

      // 2. التحويل الآمن لـ course_id
      courseId: int.tryParse(json['course_id'].toString()) ?? 0,

      // 3. قراءة اسم المقرر من الخادم
      courseName: json['course_name'] ?? 'مقرر غير محدد',

      examDate: json['exam_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      type: json['type'] ?? 'غير محدد',
      targetYear: json['target_year'],
    );
  }
}
