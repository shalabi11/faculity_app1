// lib/features/teachers/data/datasource/teacher_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
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

  // --- تم تعديل هذه الدالة ---
  @override
  Future<void> addTeacher({required Map<String, dynamic> teacherData}) async {
    try {
      await dio.post(
        '$baseUrl/api/teachers',
        data: FormData.fromMap(teacherData),
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      // التعامل بشكل خاص مع أخطاء التحقق
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.entries
              .map((entry) {
                final field = entry.key;
                final messages = (entry.value as List).join(', ');
                return '$field: $messages';
              })
              .join('\n');
          throw ServerException(message: 'خطأ في التحقق:\n$errorMessages');
        }
      }
      handleDioException(e); // التعامل مع باقي الأخطاء
    }
  }

  // --- وتم تعديل هذه الدالة أيضًا ---
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
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>?;
        if (errors != null) {
          final errorMessages = errors.entries
              .map((entry) {
                final field = entry.key;
                final messages = (entry.value as List).join(', ');
                return '$field: $messages';
              })
              .join('\n');
          throw ServerException(message: 'خطأ في التحقق:\n$errorMessages');
        }
      }
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
}
