// lib/features/exams/domain/repositories/exams_repository.dart

import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart'; // <-- أضفنا هذا

abstract class ExamsRepository {
  Future<List<Exam>> getExams();
  Future<void> addExam({required Map<String, dynamic> examData});
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  });
  Future<void> deleteExam({required int id});
  // --- أضفنا هذه الدالة ---
  Future<List<ExamResult>> getStudentResults({required int studentId});
}
