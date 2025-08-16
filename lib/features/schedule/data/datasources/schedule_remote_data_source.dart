import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/core/utils/constant.dart' as Constants;
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/data/models/schedule_entry_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year);
  Future<List<ScheduleEntryModel>> getLabSchedule(String group, String section);
  Future<void> addSchedule(Map<String, dynamic> scheduleData);
  Future<void> deleteSchedule(int id);
  Future<void> updateSchedule(int id, Map<String, dynamic> scheduleData);
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ScheduleRemoteDataSourceImpl({
    required this.dio,
    required this.secureStorage,
  });

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<void> addSchedule(Map<String, dynamic> scheduleData) async {
    try {
      await dio.post(
        '$baseUrl/api/schedules',
        data: scheduleData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.entries
              .map(
                (entry) => '${entry.key}: ${(entry.value as List).join(', ')}',
              )
              .join('\n');
          throw ServerException(message: 'خطأ في التحقق:\n$errorMessages');
        }
      }
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteSchedule(int id) async {
    try {
      await dio.delete(
        '$baseUrl/api/schedules/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year) async {
    try {
      final response = await dio.get(
        '${Constants.baseUrl}/api/schedules/theory/$year',
        options: await _getAuthHeaders(),
      );

      // التعامل مع أكثر من صيغة للرد
      final rawData = response.data;
      List<dynamic> dataList;

      if (rawData is List) {
        dataList = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        dataList = rawData['data'];
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة.');
      }

      return dataList.map((json) => ScheduleEntryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'فشل تحميل الجدول النظري.');
    }
  }

  @override
  Future<List<ScheduleEntryModel>> getLabSchedule(
    String group,
    String section,
  ) async {
    try {
      final response = await dio.get(
        '${Constants.baseUrl}/api/schedules/lab/$group/$section',
        options: await _getAuthHeaders(),
      );

      // التعامل مع أكثر من صيغة للرد
      final rawData = response.data;
      List<dynamic> dataList;

      if (rawData is List) {
        dataList = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        dataList = rawData['data'];
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة.');
      }

      return dataList.map((json) => ScheduleEntryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'فشل تحميل الجدول العملي.');
    }
  }

  @override
  Future<void> updateSchedule(int id, Map<String, dynamic> scheduleData) async {
    try {
      await dio.put(
        '$baseUrl/api/schedules/$id',
        data: scheduleData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
