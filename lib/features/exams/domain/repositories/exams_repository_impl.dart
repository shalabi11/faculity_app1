import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/exams/data/datasource/exams_remote_data_source.dart';

import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_distribution_result_entity.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  final ExamRemoteDataSource remoteDataSource;

  ExamRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExamEntity>>> getAllExams() async {
    try {
      final examList = await remoteDataSource.getAllExams();
      return Right(examList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExam({required int id}) async {
    try {
      await remoteDataSource.deleteExam(id: id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    try {
      await remoteDataSource.updateExam(id: id, examData: examData);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addExam({
    required Map<String, dynamic> examData,
  }) async {
    try {
      await remoteDataSource.addExam(examData: examData);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ExamResultEntity>>> getStudentsForExam(
    int examId,
  ) async {
    try {
      final students = await remoteDataSource.getStudentsForExam(examId);
      return Right(students);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveGrades(
    List<Map<String, dynamic>> grades,
  ) async {
    try {
      await remoteDataSource.saveGrades(grades);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ExamDistributionResultEntity>>> distributeHalls(
    int examId,
  ) async {
    try {
      final results = await remoteDataSource.distributeHalls(examId);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
