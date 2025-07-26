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
      id: json['id'],
      // نفترض أن الخادم يرسل اسم المقرر داخل كائن course
      courseName:
          json['course'] != null ? json['course']['name'] : 'مقرر غير محدد',
      examDate: json['exam_date'] ?? '',
      courseId: json['course_id'], // <-- أضف هذا السطر
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      type: json['type'] ?? 'غير محدد',
      targetYear: json['target_year'],
    );
  }
}
