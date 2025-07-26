import 'package:faculity_app2/features/exams/domain/enteties/exam_distribution_result_entity.dart';

class ExamDistributionResultModel extends ExamDistributionResultEntity {
  const ExamDistributionResultModel({
    required super.studentName,
    required super.universityId,
    required super.classroomName,
  });

  factory ExamDistributionResultModel.fromJson(Map<String, dynamic> json) {
    return ExamDistributionResultModel(
      studentName: json['student_name'] ?? 'غير متوفر',
      universityId: json['university_id'] ?? 'غير متوفر',
      classroomName: json['classroom_name'] ?? 'غير محدد',
    );
  }
}
