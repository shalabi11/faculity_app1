// lib/features/schedule/domain/repositories/schedule_repository.dart

import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ScheduleEntity>>> getTheorySchedule(String year);
  // Add section parameter here
  Future<List<ScheduleEntity>> getLabSchedule(String group, String section);
  Future<Either<Failure, Unit>> addSchedule(Map<String, dynamic> scheduleData);
  Future<Either<Failure, Unit>> deleteSchedule(int id);
  Future<Either<Failure, Unit>> updateSchedule(
    int id,
    Map<String, dynamic> scheduleData,
  );
}
