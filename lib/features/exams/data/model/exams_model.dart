import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

class ExamModel extends Exam {
  const ExamModel({
    required super.id,
    required super.courseName,
    required super.examDate,
    required super.startTime,
    required super.endTime,
    required super.type,
    super.targetYear,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      // تحويل آمن للـ ID
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      courseName: json['course_name'] ?? 'مادة غير معروفة',

      // --- التصحيح الجذري هنا ---
      // تحويل آمن جداً للتاريخ
      examDate: DateTime.tryParse(json['exam_date'] ?? '') ?? DateTime.now(),

      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      type: json['type'] ?? 'نوع غير محدد',
      targetYear: json['target_year'],
    );
  }
}
