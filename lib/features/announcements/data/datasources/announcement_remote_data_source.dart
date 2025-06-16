// lib/features/announcements/data/datasources/announcement_remote_data_source.dart
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';

import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncements();
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final Dio dio;
  AnnouncementRemoteDataSourceImpl({required this.dio});

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
}
