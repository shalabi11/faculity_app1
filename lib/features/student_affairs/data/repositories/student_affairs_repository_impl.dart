// lib/features/student_affairs/data/repositories/student_affairs_repository_impl.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/platform/network_info.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/datasource/student_affairs_remote_data_source.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

class StudentAffairsRepositoryImpl implements StudentAffairsRepository {
  final StudentAffairsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StudentAffairsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Student>>> getStudents() async {
    if (await networkInfo.isConnected) {
      try {
        final students = await remoteDataSource.getStudents();
        return Right(students);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addStudent(
          studentData: studentData,
          image: image,
        );
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateStudent(id: id, studentData: studentData);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteStudent({required int id}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteStudent(id: id);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
