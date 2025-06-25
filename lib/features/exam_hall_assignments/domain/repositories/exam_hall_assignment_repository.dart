// lib/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository.dart

import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';

abstract class ExamHallAssignmentRepository {
  Future<void> distributeHalls({required int examId});
  Future<List<ExamHallAssignment>> getHallAssignments({required int examId});
}
