// lib/features/exams/data/model/exams_result_model.dart
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

class ExamResultModel extends ExamResultEntity {
  const ExamResultModel({
    required super.resultId,
    required super.studentId,
    required super.studentName,
    required super.courseName,
    super.score,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      resultId: int.tryParse(json['id'].toString()) ?? 0,
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,
      studentName: json['student_name'] ?? 'اسم غير متوفر',
      // ✨ تم التحديث هنا لقراءة اسم المادة
      courseName: json['course_name'] ?? 'مادة غير معروفة',
      score:
          json['score'] != null
              ? double.tryParse(json['score'].toString())
              : null,
    );
  }
}
