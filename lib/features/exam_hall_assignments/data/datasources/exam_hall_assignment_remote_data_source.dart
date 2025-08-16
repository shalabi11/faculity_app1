// lib/features/exam_hall_assignments/data/datasource/exam_hall_assignment_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/exam_hall_assignments/data/models/exam_hall_assignment_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ExamHallAssignmentRemoteDataSource {
  Future<void> distributeHalls({required int examId});
  Future<List<ExamHallAssignmentModel>> getHallAssignments({
    required int examId,
  });
}

class ExamHallAssignmentRemoteDataSourceImpl
    implements ExamHallAssignmentRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ExamHallAssignmentRemoteDataSourceImpl({
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
  Future<void> distributeHalls({required int examId}) async {
    try {
      await dio.post(
        '$baseUrl/api/exam-hall-assignments/distribute',
        data: {'exam_id': examId},
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ExamHallAssignmentModel>> getHallAssignments({
    required int examId,
  }) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exam-hall-assignments/$examId',
        options: await _getAuthHeaders(),
      );

      // ✨ --- تم التعديل الكامل هنا --- ✨
      if (response.statusCode == 200) {
        // التحقق من نوع البيانات المستقبلة
        if (response.data is List) {
          // إذا كانت قائمة مباشرة، تعامل معها مباشرة
          final List<dynamic> data = response.data;
          return data
              .map((json) => ExamHallAssignmentModel.fromJson(json))
              .toList();
        } else if (response.data is Map<String, dynamic> &&
            response.data['assignments'] is List) {
          // إذا كانت خريطة تحتوي على مفتاح 'assignments'، استخرج القائمة منها
          final List<dynamic> data = response.data['assignments'];
          return data
              .map((json) => ExamHallAssignmentModel.fromJson(json))
              .toList();
        } else {
          // في حال كانت بنية البيانات غير متوقعة
          throw ServerException(message: 'Failed to parse hall assignments');
        }
      } else {
        throw ServerException(message: 'Failed to load hall assignments');
      }
    } on DioException catch (e) {
      handleDioException(e);
      // هذا السطر لن يتم الوصول إليه غالباً لأن الدالة السابقة سترمي الخطأ
      throw ServerException(message: 'Network error');
    }
  }
}
