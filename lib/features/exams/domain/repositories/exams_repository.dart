import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_distribution_result_entity.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

abstract class ExamRepository {
  Future<Either<Failure, List<ExamEntity>>> getAllExams();
  Future<Either<Failure, Unit>> deleteExam({required int id});
  Future<Either<Failure, Unit>> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  });
  Future<Either<Failure, Unit>> addExam({
    required Map<String, dynamic> examData,
  });
  Future<Either<Failure, List<ExamResultEntity>>> getStudentsForExam(
    int examId,
  );
  Future<Either<Failure, Unit>> saveGrades(List<Map<String, dynamic>> grades);
  Future<Either<Failure, List<ExamDistributionResultEntity>>> distributeHalls(
    int examId,
  );
}
