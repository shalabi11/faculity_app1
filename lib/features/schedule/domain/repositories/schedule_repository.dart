// lib/features/schedule/domain/repositories/schedule_repository.dart
import '../entities/schedule_entry.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntry>> getTheorySchedule(String year);
  Future<List<ScheduleEntry>> getLabSchedule(String group);
}
