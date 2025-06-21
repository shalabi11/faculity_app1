import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  });
  Future<void> updateAnnouncement({
    required int id,
    required Map<String, String> data,
  });
  Future<void> deleteAnnouncement({required int id});
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AnnouncementRemoteDataSourceImpl({
    required this.dio,
    required this.secureStorage,
  });

  // دالة مساعدة للحصول على التوكن وإضافته للهيدر
  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) {
      throw ServerException(message: 'User not authenticated');
    }
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<AnnouncementModel>> getAnnouncements() async {
    try {
      final response = await dio.get('$baseUrl/api/announcements');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load announcements');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error'); // Unreachable
    }
  }

  @override
  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  }) async {
    try {
      final formData = FormData.fromMap(data);
      if (filePath != null && filePath.isNotEmpty) {
        formData.files.add(
          MapEntry('attachment', await MultipartFile.fromFile(filePath)),
        );
      }
      await dio.post(
        '$baseUrl/api/announcements',
        data: formData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> updateAnnouncement({
    required int id,
    required Map<String, String> data,
  }) async {
    try {
      // الـ API يتوقع x-www-form-urlencoded لتحديث البيانات النصية
      // لذلك نستخدم `data` مباشرة وليس FormData
      // ولأن HTML forms لا تدعم PUT، نستخدم POST مع حقل _method
      final requestData = Map<String, String>.from(data)
        ..addAll({'_method': 'PUT'});
      await dio.post(
        '$baseUrl/api/announcements/$id',
        data: requestData,
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteAnnouncement({required int id}) async {
    try {
      await dio.delete(
        '$baseUrl/api/announcements/$id',
        options: await _getAuthHeaders(),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
