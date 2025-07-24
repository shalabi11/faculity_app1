import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ScheduleEntity>>> getTheorySchedule(
    String year,
  ) async {
    try {
      final schedule = await remoteDataSource.getTheorySchedule(year);
      return Right(schedule);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<List<ScheduleEntity>> getLabSchedule(
    String group,
    String section,
  ) async {
    try {
      // Pass the section parameter to the remote data source
      return await remoteDataSource.getLabSchedule(group, section);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get lab schedule: ${e.toString()}');
    }
  }

  // ملاحظة: دوال الإضافة والحذف ستضاف هنا بنفس الطريقة لاحقاً
  @override
  Future<Either<Failure, Unit>> addSchedule(
    Map<String, dynamic> scheduleData,
  ) async {
    try {
      await remoteDataSource.addSchedule(scheduleData);
      return const Right(unit); // Return Right(unit) on success
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message),
      ); // Return Left(Failure) on error
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSchedule(int id) async {
    try {
      await remoteDataSource.deleteSchedule(id);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSchedule(
    int id,
    Map<String, dynamic> scheduleData,
  ) async {
    try {
      await remoteDataSource.updateSchedule(id, scheduleData);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
