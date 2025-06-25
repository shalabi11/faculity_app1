// lib/features/exam_hall_assignments/domain/entities/exam_hall_assignment.dart

class ExamHallAssignment {
  final String studentName;
  final String universityId;
  final String classroomName;

  const ExamHallAssignment({
    required this.studentName,
    required this.universityId,
    required this.classroomName,
  });
}
