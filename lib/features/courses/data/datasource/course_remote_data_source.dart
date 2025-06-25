import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/courses/data/models/course_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses();
  Future<void> addCourse({required Map<String, dynamic> courseData});
  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  });
  Future<void> deleteCourse({required int id});
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
  Future<List<CourseModel>> getCourses() async {
    final response = await dio.get(
      '$baseUrl/api/course',
      options: await _getAuthHeaders(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['courses'];
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to load courses');
    }
  }

  @override
  Future<void> addCourse({required Map<String, dynamic> courseData}) async {
    await dio.post(
      '$baseUrl/api/course',
      data: courseData,
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  }) async {
    await dio.put(
      '$baseUrl/api/course/$id',
      data: courseData,
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<void> deleteCourse({required int id}) async {
    await dio.delete(
      '$baseUrl/api/course/$id',
      options: await _getAuthHeaders(),
    );
  }
}
