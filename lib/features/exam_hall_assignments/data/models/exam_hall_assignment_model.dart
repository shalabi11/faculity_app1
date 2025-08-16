// lib/features/exam_hall_assignments/data/models/exam_hall_assignment_model.dart

import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';

class ExamHallAssignmentModel extends ExamHallAssignment {
  const ExamHallAssignmentModel({
    required super.studentName,
    required super.universityId,
    required super.classroomName,
  });

  factory ExamHallAssignmentModel.fromJson(Map<String, dynamic> json) {
    // ✨ ---  تم تعديل هذا الجزء بالكامل --- ✨
    // الآن نقوم بقراءة البيانات مباشرة من الكائن الرئيسي
    return ExamHallAssignmentModel(
      studentName: json['student_name'] ?? 'طالب غير معروف',
      universityId: json['university_id'] ?? 'رقم غير معروف',
      classroomName: json['classroom_name'] ?? 'قاعة غير معروفة',
    );
  }
}
