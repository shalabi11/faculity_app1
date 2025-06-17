import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

class ExamModel extends Exam {
  ExamModel({
    required super.id,
    required super.courseName,
    required super.date,
    required super.startTime,
    required super.endTime,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    final courseData = json['course'] as Map<String, dynamic>? ?? {};
    return ExamModel(
      id: json['id'] ?? 0,
      courseName: courseData['name'] ?? 'مادة غير محددة',
      date: json['exam_date'] ?? 'تاريخ غير محدد',
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
    );
  }
}
