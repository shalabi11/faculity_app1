// lib/features/teachers/data/datasources/teacher_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/data/models/schedule_entry_model.dart';
import 'package:faculity_app2/features/teachers/data/models/teachers_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TeacherRemoteDataSource {
  Future<List<TeacherModel>> getTeachers();
  Future<void> addTeacher({required Map<String, dynamic> teacherData});
  Future<void> updateTeacher({
    required int id,
    required Map<String, dynamic> teacherData,
  });
  Future<void> deleteTeacher({required int id});
  // ✨ --- تم تعديل نوع الإرجاع هنا --- ✨
  Future<List<ScheduleEntryModel>> getTeacherSchedule(int teacherId);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  TeacherRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<TeacherModel>> getTeachers() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/teachers',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TeacherModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load teachers');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }

  @override
  Future<void> addTeacher({required Map<String, dynamic> teacherData}) async {
    try {
      await dio.post(
        '$baseUrl/api/teachers',
        data: FormData.fromMap(teacherData),
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> updateTeacher({
    required int id,
    required Map<String, dynamic> teacherData,
  }) async {
    try {
      final formData = FormData.fromMap({...teacherData, '_method': 'PUT'});
      await dio.post(
        '$baseUrl/api/teachers/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteTeacher({required int id}) async {
    try {
      await dio.delete(
        '$baseUrl/api/teachers/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ScheduleEntryModel>> getTeacherSchedule(int teacherId) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/schedules/teacher/$teacherId',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.data['data'] is List) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ScheduleEntryModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load teacher schedule');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}
