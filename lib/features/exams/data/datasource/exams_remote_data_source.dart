import 'package:dio/dio.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/exams/data/model/exam_distribution_result_model.dart';
import 'package:faculity_app2/features/exams/data/model/exams_model.dart';
import 'package:faculity_app2/features/exams/data/model/exams_result_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';

abstract class ExamRemoteDataSource {
  Future<List<ExamModel>> getAllExams();
  Future<void> deleteExam({required int id});
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  });
  Future<void> addExam({required Map<String, dynamic> examData});
  Future<List<ExamResultModel>> getStudentsForExam(int examId);
  Future<void> saveGrades(List<Map<String, dynamic>> grades);
  Future<List<ExamDistributionResultModel>> distributeHalls(int examId);
  Future<List<ExamResultModel>> getStudentResults(int studentId);
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ExamRemoteDataSourceImpl({required this.dio, required this.secureStorage});
  @override
  Future<List<ExamResultModel>> getStudentResults(int studentId) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exam-results/student/$studentId',
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => ExamResultModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل جلب نتائج الطالب");
    }
  }

  @override
  Future<List<ExamModel>> getAllExams() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final response = await dio.get('$baseUrl/api/exams', options: options);

      // --- هذا هو التصحيح ---
      // نتأكد من أن الرد هو قائمة مباشرة
      if (response.statusCode == 200 && response.data is List) {
        // نتعامل مع response.data مباشرة لأنها هي القائمة
        final List<dynamic> data = response.data;
        return data.map((examJson) => ExamModel.fromJson(examJson)).toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل الاتصال بالخادم");
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
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    try {
      // Laravel يتوقع طلب POST لتحديث البيانات مع حقل _method=PUT
      final formData = FormData.fromMap({...examData, '_method': 'PUT'});

      await dio.post(
        '$baseUrl/api/exams/$id',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<void> addExam({required Map<String, dynamic> examData}) async {
    try {
      final formData = FormData.fromMap(examData);
      await dio.post(
        '$baseUrl/api/exams',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ExamResultModel>> getStudentsForExam(int examId) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exam-results/exam/$examId',
        options: await _getAuthHeaders(),
      );

      // --- هذا هو التصحيح ---
      // نتأكد من أن الرد هو قائمة مباشرة
      if (response.statusCode == 200 && response.data is List) {
        // نتعامل مع response.data مباشرة لأنها هي القائمة
        final List<dynamic> data = response.data;
        return data.map((json) => ExamResultModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل جلب الطلاب");
    }
  }

  @override
  Future<void> saveGrades(List<Map<String, dynamic>> grades) async {
    try {
      // الخادم يتوقع قائمة من النتائج
      await dio.post(
        '$baseUrl/api/exam-results/bulk-update', // تأكد من أن هذا هو المسار الصحيح
        data: {'results': grades},
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<List<ExamDistributionResultModel>> distributeHalls(int examId) async {
    try {
      // تأكد من أن هذا هو المسار الصحيح من Postman
      final response = await dio.post(
        '$baseUrl/api/exam-hall-assignments/distribute',
        data: {'exam_id': examId},
        options: await _getAuthHeaders(),
      );

      if (response.statusCode == 200 && response.data['assignments'] is List) {
        return (response.data['assignments'] as List)
            .map((json) => ExamDistributionResultModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل تنفيذ عملية التوزيع");
    }
  }
}
