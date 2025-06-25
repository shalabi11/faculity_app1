// lib/features/schedule/data/datasources/schedule_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/data/models/schedule_entry_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year);
  Future<List<ScheduleEntryModel>> getLabSchedule(String group);
  Future<void> addSchedule(Map<String, dynamic> scheduleData);
  Future<void> deleteSchedule(int id);
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
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  // @override
  // Future<List<ScheduleEntryModel>> getTheorySchedule(String year) async {
  //   // ... (هذه الدالة تبقى كما هي)
  // }

  // @override
  // Future<List<ScheduleEntryModel>> getLabSchedule(String group) async {
  //   // ... (هذه الدالة تبقى كما هي)
  // }

  // --- تم تعديل معالجة الأخطاء هنا ---
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
              .map((entry) {
                return '${entry.key}: ${(entry.value as List).join(', ')}';
              })
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
  Future<List<ScheduleEntryModel>> getLabSchedule(String group) {
    // TODO: implement getLabSchedule
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleEntryModel>> getTheorySchedule(String year) {
    // TODO: implement getTheorySchedule
    throw UnimplementedError();
  }
}
