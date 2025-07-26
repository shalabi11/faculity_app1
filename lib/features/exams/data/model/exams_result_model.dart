import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

class ExamResultModel extends ExamResultEntity {
  const ExamResultModel({
    required super.resultId,
    required super.studentId,
    required super.studentName,
    super.score,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) {
    return ExamResultModel(
      // نفترض أن الخادم يرسل هذه الحقول
      resultId:
          json['result_id'] ??
          0, // ID النتيجة نفسها، قد يكون 0 إذا لم توجد علامة بعد
      studentId: json['student_id'],
      studentName: json['student_name'] ?? 'اسم غير متوفر',
      // تحويل آمن للعلامة، قد تكون غير موجودة (null)
      score:
          json['score'] != null
              ? double.tryParse(json['score'].toString())
              : null,
    );
  }
}
