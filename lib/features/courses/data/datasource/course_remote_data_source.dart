import 'package:dio/dio.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/courses/data/models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getAllCourses();
  Future<void> addCourse(Map<String, dynamic> courseData);
  Future<void> updateCourse(int id, Map<String, dynamic> courseData);
  Future<void> deleteCourse(int id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  CourseRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final response = await dio.get('$baseUrl/api/course', options: options);

      // Check if the response is successful and the data is a Map
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        // **The fix is here: Access the 'courses' key from the response data**
        final List<dynamic> courseListJson = response.data['courses'] as List;

        return courseListJson
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل الاتصال بالخادم");
    }
  }

  @override
  Future<void> addCourse(Map<String, dynamic> courseData) async {
    try {
      await dio.post(
        '$baseUrl/api/course',
        data: courseData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> updateCourse(int id, Map<String, dynamic> courseData) async {
    try {
      final options = await _getAuthHeaders();
      options.method = 'PUT'; // or use dio.put
      await dio.post(
        '$baseUrl/api/course/$id', // Laravel often uses POST for updates with _method
        data: {...courseData, '_method': 'PUT'},
        options: options,
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      await dio.delete(
        '$baseUrl/api/course/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
