import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

abstract class ExamsRepository {
  Future<List<Exam>> getExams();
  Future<List<ExamResult>> getStudentResults(int studentId);
}
