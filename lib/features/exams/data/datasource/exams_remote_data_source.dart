// lib/features/exams/data/datasource/exams_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/exams/data/model/exams_model.dart';
import 'package:faculity_app2/features/exams/data/model/exams_result_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ExamsRemoteDataSource {
  Future<List<ExamModel>> getExams();
  Future<void> addExam({required Map<String, dynamic> examData});
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  });
  Future<void> deleteExam({required int id});
  Future<List<ExamResultModel>> getStudentResults({required int studentId});
}

class ExamsRemoteDataSourceImpl implements ExamsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ExamsRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<ExamModel>> getExams() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exams',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        // --- التعديل الرئيسي هنا ---
        // نقرأ من response.data مباشرة لأنها هي القائمة
        final List<dynamic> data = response.data ?? [];
        return data.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load exams');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network Error');
    }
  }

  // ... باقي الدوال تبقى كما هي
  @override
  Future<void> addExam({required Map<String, dynamic> examData}) async {
    try {
      await dio.post(
        '$baseUrl/api/exams',
        data: examData,
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
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    try {
      await dio.put(
        '$baseUrl/api/exams/$id',
        data: examData,
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
  Future<void> deleteExam({required int id}) async {
    try {
      await dio.delete(
        '$baseUrl/api/exams/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ExamResultModel>> getStudentResults({
    required int studentId,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exam-results/student/$studentId',
        options: await _getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['exam_results'] ?? [];
        return data.map((json) => ExamResultModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load student results');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}
