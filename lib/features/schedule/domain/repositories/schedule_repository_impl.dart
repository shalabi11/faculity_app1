// lib/features/schedule/data/repositories/schedule_repository_impl.dart
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';

import '../entities/schedule_entry.dart';
import 'schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ScheduleEntry>> getTheorySchedule(String year) async {
    return await _executeCall(() => remoteDataSource.getTheorySchedule(year));
  }

  @override
  Future<List<ScheduleEntry>> getLabSchedule(String group) async {
    return await _executeCall(() => remoteDataSource.getLabSchedule(group));
  }

  // دالة مساعدة لتجنب تكرار كود معالجة الأخطاء
  Future<List<ScheduleEntry>> _executeCall(
    Future<List<ScheduleEntry>> Function() call,
  ) async {
    try {
      return await call();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }
}
