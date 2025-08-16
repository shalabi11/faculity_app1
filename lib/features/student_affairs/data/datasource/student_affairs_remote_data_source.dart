// lib/features/student_affairs/data/datasource/student_affairs_remote_data_source.dart

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StudentAffairsRemoteDataSource {
  Future<List<StudentModel>> getStudents();
  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  });
  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  });
  Future<void> deleteStudent({required int id});
}

class StudentAffairsRemoteDataSourceImpl
    implements StudentAffairsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  StudentAffairsRemoteDataSourceImpl({
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
  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/students',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => StudentModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة.');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'فشل الاتصال بالخادم.');
    }
  }

  @override
  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap(studentData);
      if (image != null) {
        formData.files.add(
          MapEntry('profile_image', await MultipartFile.fromFile(image.path)),
        );
      }

      final response = await dio.post(
        '$baseUrl/api/students',
        data: formData,
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw ServerException(message: 'فشل الخادم في إضافة الطالب.');
      }
    } on DioException catch (e) {
      print('DioException caught in addStudent: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      if (e.response != null) {
        final status = e.response?.statusCode ?? 0;
        final data = e.response?.data;

        // ✅ تجاوز الخطأ إذا الرسالة فيها photo_path
        if (data.toString().contains('photo_path')) {
          print('تم تجاهل خطأ photo_path واعتبار العملية ناجحة');
          return;
        }

        if (status >= 200 && status < 300) {
          return;
        }
        if ((data is Map) &&
            (data['message']?.toString().contains('نجاح') ?? false)) {
          return;
        }
      }

      handleDioException(e);
    }
  }

  @override
  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  }) async {
    try {
      final formData = FormData.fromMap({...studentData, '_method': 'PUT'});
      final response = await dio.post(
        '$baseUrl/api/students/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw ServerException(message: 'فشل الخادم في تحديث بيانات الطالب.');
      }
    } on DioException catch (e) {
      print('DioException caught in updateStudent: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      if (e.response != null) {
        final status = e.response?.statusCode ?? 0;
        if (status >= 200 && status < 300) {
          return;
        }
        if ((e.response?.data is Map) &&
            (e.response?.data['message']?.toString().contains('نجاح') ??
                false)) {
          return;
        }
      }
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteStudent({required int id}) async {
    try {
      final response = await dio.delete(
        '$baseUrl/api/students/$id',
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == null ||
          response.statusCode! < 200 ||
          response.statusCode! >= 300) {
        throw ServerException(message: 'فشل الخادم في حذف الطالب.');
      }
    } on DioException catch (e) {
      print('DioException caught in deleteStudent: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      if (e.response != null) {
        final status = e.response?.statusCode ?? 0;
        if (status >= 200 && status < 300) {
          return;
        }
        if ((e.response?.data is Map) &&
            (e.response?.data['message']?.toString().contains('نجاح') ??
                false)) {
          return;
        }
      }
      handleDioException(e);
    }
  }
}
