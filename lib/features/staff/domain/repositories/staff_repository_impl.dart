import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/domain/repositories/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remoteDataSource;

  StaffRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<StaffEntity>>> getAllStaff() async {
    try {
      final staffList = await remoteDataSource.getAllStaff();
      return Right(staffList);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addStaff(Map<String, dynamic> staffData) async {
    try {
      await remoteDataSource.addStaff(staffData);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteStaff(int staffId) async {
    try {
      await remoteDataSource.deleteStaff(staffId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStaff(
    int staffId,
    Map<String, dynamic> staffData,
  ) async {
    try {
      await remoteDataSource.updateStaff(staffId, staffData);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
