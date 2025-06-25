// lib/features/exam_hall_assignments/data/models/exam_hall_assignment_model.dart

import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';

class ExamHallAssignmentModel extends ExamHallAssignment {
  const ExamHallAssignmentModel({
    required super.studentName,
    required super.universityId,
    required super.classroomName,
  });

  factory ExamHallAssignmentModel.fromJson(Map<String, dynamic> json) {
    // نفترض أن الخادم سيرجع كائنات متداخلة للطالب والقاعة
    final studentData = json['student'] as Map<String, dynamic>? ?? {};
    final classroomData = json['classroom'] as Map<String, dynamic>? ?? {};

    return ExamHallAssignmentModel(
      studentName: studentData['full_name'] ?? 'طالب غير معروف',
      universityId: studentData['university_id'] ?? 'رقم غير معروف',
      classroomName: classroomData['name'] ?? 'قاعة غير معروفة',
    );
  }
}
