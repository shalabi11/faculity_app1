// lib/features/schedule/domain/repositories/schedule_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ScheduleEntry>> getTheorySchedule(String year) async {
    try {
      return await remoteDataSource.getTheorySchedule(year);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get theory schedule: ${e.toString()}');
    }
  }

  @override
  Future<List<ScheduleEntry>> getLabSchedule(String group) async {
    try {
      return await remoteDataSource.getLabSchedule(group);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get lab schedule: ${e.toString()}');
    }
  }

  @override
  Future<void> addSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await remoteDataSource.addSchedule(scheduleData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add schedule entry: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteSchedule(int id) async {
    try {
      await remoteDataSource.deleteSchedule(id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete schedule entry: ${e.toString()}');
    }
  }
}
