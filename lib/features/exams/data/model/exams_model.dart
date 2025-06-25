// lib/features/exams/data/model/exams_model.dart

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
      id: int.tryParse(json['id'].toString()) ?? 0,
      // نقرأ اسم المادة مباشرة
      courseName: json['course_name'] ?? 'مادة غير معروفة',
      examDate: json['exam_date'] ?? 'تاريخ غير محدد',
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      type: json['type'] ?? 'نوع غير محدد',
      targetYear: json['target_year'],
    );
  }
}
