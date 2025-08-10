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
      // 1. التحويل الآمن للـ ID، مع قيمة افتراضية في حالة كان فارغاً
      // نفترض أن 'id' القادم من الخادم هو معرّف النتيجة
      resultId: int.tryParse(json['id'].toString()) ?? 0,

      // 2. التحويل الآمن لـ student_id، مع قيمة افتراضية لأنه غير موجود حالياً
      studentId: int.tryParse(json['student_id'].toString()) ?? 0,

      // 3. قراءة اسم الطالب
      studentName: json['student_name'] ?? 'اسم غير متوفر',

      // 4. التحويل الآمن للعلامة
      score:
          json['score'] != null
              ? double.tryParse(json['score'].toString())
              : null,
    );
  }
}
