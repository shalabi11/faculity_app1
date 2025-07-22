// lib/features/announcements/data/datasources/announcement_remote_data_source.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/announcements/data/models/announcement_model.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    required Object client,
  });

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

      // يمكنك حذف سطر الطباعة الآن إذا أردت
      // print('RAW ANNOUNCEMENTS RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        // ======================= التعديل النهائي هنا =======================
        // نقرأ من response.data مباشرة لأنها هي القائمة
        final List<dynamic> data = response.data;
        // ===================================================================
        return data.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load announcements');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }

  @override
  Future<void> addAnnouncement({
    required Map<String, String> data,
    String? filePath,
  }) async {
    try {
      final formData = FormData.fromMap(data);
      if (filePath != null) {
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
      await dio.put(
        '$baseUrl/api/announcements/$id',
        data: data,
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
