// lib/features/schedule/data/datasources/schedule_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/utils/constant.dart';

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';

import '../models/schedule_entry_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year);
  Future<List<ScheduleEntryModel>> getLabSchedule(String group);
}

// ... abstract class يبقى كما هو

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;
  ScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year) async {
    return _getScheduleFromUrl(
      '$baseUrl/api/schedules/theory/$year',
    ); // <-- استخدام المتغير
  }

  @override
  Future<List<ScheduleEntryModel>> getLabSchedule(String group) async {
    return _getScheduleFromUrl(
      '$baseUrl/api/schedules/lab/$group',
    ); // <-- استخدام المتغير
  }

  Future<List<ScheduleEntryModel>> _getScheduleFromUrl(String url) async {
    // ... محتوى الدالة يبقى كما هو
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ScheduleEntryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load schedule');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}
