// lib/features/classrooms/data/datasource/classroom_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/classrooms/data/models/classroom_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ClassroomRemoteDataSource {
  Future<List<ClassroomModel>> getClassrooms();
  Future<void> addClassroom({required Map<String, dynamic> classroomData});
  Future<void> updateClassroom({
    required int id,
    required Map<String, dynamic> classroomData,
  });
  Future<void> deleteClassroom({required int id});
}

class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ClassroomRemoteDataSourceImpl({
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

  @override
  Future<List<ClassroomModel>> getClassrooms() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/classroom',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        // --- التعديل الرئيسي هنا ---
        // اسم المفتاح الصحيح هو "courses" وليس "classrooms"
        final List<dynamic> data = response.data['courses'] ?? [];
        return data.map((json) => ClassroomModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load classrooms');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }

  @override
  Future<void> addClassroom({
    required Map<String, dynamic> classroomData,
  }) async {
    await dio.post(
      '$baseUrl/api/classroom',
      data: classroomData,
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<void> updateClassroom({
    required int id,
    required Map<String, dynamic> classroomData,
  }) async {
    await dio.put(
      '$baseUrl/api/classroom/$id',
      data: classroomData,
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<void> deleteClassroom({required int id}) async {
    await dio.delete(
      '$baseUrl/api/classroom/$id',
      options: await _getAuthHeaders(),
    );
  }
}
