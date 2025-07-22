import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

class ExamResultModel extends ExamResult {
  ExamResultModel({
    required super.id,
    required super.courseName,
    required super.score,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    // ---- هذا هو الكود المحصن ----

    final examData = json['exam'] as Map<String, dynamic>? ?? {};
    final courseData = examData['course'] as Map<String, dynamic>? ?? {};

    // 1. التحويل الآمن للدرجة (score)
    final scoreValue = json['score'];
    double parsedScore = 0.0;
    if (scoreValue != null) {
      parsedScore = double.tryParse(scoreValue.toString()) ?? 0.0;
    }

    // 2. التحويل الآمن للـ ID
    final idValue = json['id'];
    int parsedId = 0;
    if (idValue != null) {
      parsedId = int.tryParse(idValue.toString()) ?? 0;
    }

    return ExamResultModel(
      id: parsedId,
      courseName: courseData['name'] ?? 'مادة غير محددة',
      score: parsedScore,
    );
  }
}
