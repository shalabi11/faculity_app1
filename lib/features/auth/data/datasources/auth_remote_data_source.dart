import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/utils/constant.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required Map<String, dynamic> data});
  Future<void> register({required Map<String, dynamic> data});
  Future<void> logout();
  Future<User> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  AuthRemoteDataSourceImpl({required this.dio, required this.secureStorage});

  @override
  Future<UserModel> login({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post('$baseUrl/api/login', data: data);

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.data);
        if (userModel.token != null) {
          await secureStorage.write(key: 'auth_token', value: userModel.token);
        }
        return userModel;
      } else {
        throw ServerException(message: 'خطأ غير متوقع');
      }
    } on DioException catch (e) {
      // تم تعديل هذه الدالة لتكون أكثر دقة
      handleDioException(e);
      // هذا السطر لن يتم الوصول إليه غالبًا لأن الدالة السابقة سترمي الخطأ
      throw ServerException(message: 'خطأ في الشبكة');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      if (token == null) {
        throw ServerException(message: 'No token found');
      }

      await dio.post(
        '$baseUrl/api/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      await secureStorage.delete(key: 'auth_token');
    } on DioException catch (e) {
      await secureStorage.delete(
        key: 'auth_token',
      ); // حذف التوكن حتى لو فشل الطلب
      handleDioException(e);
    }
  }

  @override
  Future<void> register({required Map<String, dynamic> data}) async {
    try {
      await dio.post(
        '$baseUrl/api/register',
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  Future<UserModel> getUserProfile() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
      if (token == null) throw ServerException(message: 'No token found');

      final response = await dio.get(
        '$baseUrl/api/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserModel.fromJson({'user': response.data['data']});
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}

// --- ✨ دالة معالجة الأخطاء بعد التعديل ✨ ---
void handleDioException(DioException e) {
  // التحقق من أخطاء الاتصال والشهادات أولاً
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.unknown ||
      e.type == DioExceptionType.badCertificate) {
    // التحقق إذا كان السبب هو مشكلة في شهادة SSL
    if (e.message != null && e.message!.contains('HandshakeException')) {
      throw ServerException(
        message:
            'خطأ في شهادة الأمان (SSL). تأكد من أن الخادم لديه شهادة صالحة.',
      );
    }
    // إذا لم يكن خطأ شهادة، فهو على الأغلب مشكلة في الاتصال
    throw ServerException(message: 'لا يوجد اتصال بالإنترنت أو الخادم متوقف.');
  }

  // معالجة باقي أنواع الأخطاء كما كانت
  switch (e.type) {
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 401:
          throw ServerException(message: 'بيانات الدخول غير صحيحة.');
        case 422:
          // محاولة قراءة رسائل الخطأ من الخادم
          final errors = e.response?.data['errors'] as Map<String, dynamic>?;
          if (errors != null && errors.isNotEmpty) {
            throw ServerException(message: errors.values.first[0]);
          }
          throw ServerException(message: 'البيانات المدخلة غير صحيحة.');
        case 500:
          throw ServerException(
            message: 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقًا.',
          );
        default:
          throw ServerException(
            message: 'حدث خطأ غير متوقع: ${e.response?.statusCode}',
          );
      }
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw ServerException(
        message: 'انتهت مهلة الاتصال، يرجى التحقق من شبكة الإنترنت.',
      );
    default:
      // للحالات الأخرى مثل `cancel`
      throw ServerException(message: 'تم إلغاء الطلب.');
  }
}
