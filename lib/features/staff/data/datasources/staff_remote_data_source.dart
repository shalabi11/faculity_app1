import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/staff/data/models/staff_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffModel>> getAllStaff();
  Future<void> addStaff(Map<String, dynamic> staffData);
  Future<void> deleteStaff(int staffId);
  Future<void> updateStaff(int staffId, Map<String, dynamic> staffData);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  StaffRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  @override
  Future<List<StaffModel>> getAllStaff() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final response = await dio.get('$baseUrl/api/staff', options: options);

      if (response.statusCode == 200 && response.data is List) {
        final List<StaffModel> staffList =
            (response.data as List)
                .map((staffJson) => StaffModel.fromJson(staffJson))
                .toList();
        return staffList;
      } else {
        throw ServerException(message: 'استجابة الخادم غير متوقعة');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: "فشل الاتصال بالخادم");
    }
  }

  @override
  Future<void> addStaff(Map<String, dynamic> staffData) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      // استخدام FormData لإرسال البيانات
      final formData = FormData.fromMap(staffData);
      // تأكد من أن هذا هو المسار الصحيح من Postman
      await dio.post('$baseUrl/api/staff', data: formData, options: options);
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> deleteStaff(int staffId) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      await dio.delete('$baseUrl/api/staff/$staffId', options: options);
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<void> updateStaff(int staffId, Map<String, dynamic> staffData) async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      final options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final formData = FormData.fromMap(staffData);
      // استخدم POST مع _method=PUT لتتوافق مع Laravel
      formData.fields.add(const MapEntry('_method', 'PUT'));
      await dio.post(
        '$baseUrl/api/staff/$staffId',
        data: formData,
        options: options,
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
