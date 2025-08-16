// lib/features/head_of_exams/data/datasources/head_of_exams_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/exams/data/model/exams_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';

abstract class HeadOfExamsRemoteDataSource {
  Future<List<ExamModel>> getPublishableExams();
  Future<void> publishExamResults(int examId);
}

class HeadOfExamsRemoteDataSourceImpl implements HeadOfExamsRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  HeadOfExamsRemoteDataSourceImpl({
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
  Future<List<ExamModel>> getPublishableExams() async {
    try {
      // ✨ --- 1. تم تعديل هذا الجزء بالكامل --- ✨
      // نفترض أن هذا المسار يجلب الامتحانات التي تم إدخال علاماتها
      final response = await dio.get(
        '$baseUrl/api/exams',
        options: await _getAuthHeaders(),
      );

      // نتعامل مع الرد الآن على أنه قائمة مباشرة
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل جلب الامتحانات");
    }
  }

  @override
  Future<void> publishExamResults(int examId) async {
    try {
      // نفترض أن هذا المسار يقوم بتغيير حالة النتائج إلى "منشورة"
      await dio.post(
        '$baseUrl/api/exams/$examId/publish',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
