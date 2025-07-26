import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/head_of_exams/data/datasources/head_of_exams_remote_data_source.dart';

import 'package:faculity_app2/features/head_of_exams/domain/repository/head_of_exams_repository.dart';

class HeadOfExamsRepositoryImpl implements HeadOfExamsRepository {
  final HeadOfExamsRemoteDataSource remoteDataSource;

  HeadOfExamsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExamEntity>>> getPublishableExams() async {
    try {
      final exams = await remoteDataSource.getPublishableExams();
      return Right(exams);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> publishExamResults(int examId) async {
    try {
      await remoteDataSource.publishExamResults(examId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
