// lib/features/student/data/datasource/student_remote_data_source.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<StudentModel>> getStudents();
  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  });
  Future<void> deleteStudent({required int id});
  // --- أضفنا هذه الدالة ---
  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  });
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  StudentRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<StudentModel>> getStudents() async {
    // ... (هذه الدالة تبقى كما هي)
    try {
      final response = await dio.get(
        '$baseUrl/api/students',
        options: await _getAuthHeaders(),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => StudentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }

  @override
  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  }) async {
    // ... (هذه الدالة تبقى كما هي)
    try {
      final formData = FormData.fromMap(studentData);
      if (image != null) {
        formData.files.add(
          MapEntry('profile_image', await MultipartFile.fromFile(image.path)),
        );
      }

      await dio.post(
        '$baseUrl/api/students',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteStudent({required int id}) async {
    // ... (هذه الدالة تبقى كما هي)
    try {
      await dio.delete(
        '$baseUrl/api/students/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  // --- وهذه هي تفاصيل تنفيذها ---
  @override
  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  }) async {
    try {
      // API التعديل يتطلب إضافة `_method` مع قيمة `PUT` عند استخدام `POST` مع `FormData`
      final formData = FormData.fromMap({...studentData, '_method': 'PUT'});

      await dio.post(
        '$baseUrl/api/students/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
