import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

class ExamResultModel extends ExamResult {
  ExamResultModel({
    required super.id,
    required super.courseName,
    required super.score,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    final examData = json['exam'] as Map<String, dynamic>? ?? {};
    final courseData = examData['course'] as Map<String, dynamic>? ?? {};

    // Ensure score is parsed correctly as a double
    final scoreValue = json['score'];
    final double parsedScore =
        scoreValue is String
            ? (double.tryParse(scoreValue) ?? 0.0)
            : (scoreValue?.toDouble() ?? 0.0);

    return ExamResultModel(
      id: json['id'] ?? 0,
      courseName: courseData['name'] ?? 'مادة غير محددة',
      score: parsedScore,
    );
  }
}
