// lib/features/users/data/datasources/app_user_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/users/data/model/app_user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AppUserRemoteDataSource {
  Future<List<AppUserModel>> getUsers();
}

class AppUserRemoteDataSourceImpl implements AppUserRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AppUserRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  Future<Options> _getAuthHeaders() async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token == null) throw ServerException(message: 'User not authenticated');
    return Options(
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
  }

  @override
  Future<List<AppUserModel>> getUsers() async {
    try {
      final response = await dio.get(
        '$baseUrl/api/users',
        options: await _getAuthHeaders(),
      );

      // ✨ --- هذا هو الجزء الذي تم تعديله --- ✨
      // الخادم على الأغلب يرسل قائمة مباشرة، وليس كائن يحتوي على مفتاح 'users'
      if (response.statusCode == 200 && response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => AppUserModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to load users');
      }
    } on DioException catch (e) {
      handleDioException(e);
      // هذا السطر لن يتم الوصول إليه غالباً لأن الدالة السابقة سترمي الخطأ
      throw ServerException(message: 'Network error');
    }
  }
}
