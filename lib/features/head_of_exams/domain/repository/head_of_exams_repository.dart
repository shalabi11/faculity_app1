import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

abstract class HeadOfExamsRepository {
  Future<Either<Failure, List<ExamEntity>>> getPublishableExams();
  Future<Either<Failure, Unit>> publishExamResults(int examId);
}
