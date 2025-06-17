import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/exams/data/model/exams_model.dart';
import 'package:faculity_app2/features/exams/data/model/exams_result_model.dart';

abstract class ExamsRemoteDataSource {
  Future<List<ExamModel>> getExams();
  Future<List<ExamResultModel>> getStudentResults(int studentId);
}

class ExamsRemoteDataSourceImpl implements ExamsRemoteDataSource {
  final Dio dio;
  ExamsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ExamModel>> getExams() async {
    try {
      final response = await dio.get('$baseUrl/api/exams');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ExamModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load exams');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }

  @override
  Future<List<ExamResultModel>> getStudentResults(int studentId) async {
    try {
      final response = await dio.get(
        '$baseUrl/api/exam-results/student/$studentId',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ExamResultModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load results');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}
