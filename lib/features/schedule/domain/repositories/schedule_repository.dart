// lib/features/schedule/domain/repositories/schedule_repository.dart

import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntry>> getTheorySchedule(String year);
  Future<List<ScheduleEntry>> getLabSchedule(String group);
  Future<void> addSchedule(Map<String, dynamic> scheduleData);
  Future<void> deleteSchedule(int id);
}
