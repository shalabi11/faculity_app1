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
      handleDioException(e);
      print('====> DIO ERROR in DataSource: $e'); // <-- أضف هذا
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
        '$baseUrl/api/register', // <-- استخدام المتغير الجديد
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

      // نفترض وجود هذا الـ endpoint لجلب بيانات المستخدم
      final response = await dio.get(
        '$baseUrl/api/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      // الـ API هنا لا تعيد 'token'، فقط 'user'
      return UserModel.fromJson({'user': response.data['data']});
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'Network error');
    }
  }
}

// --- دالة معالجة الأخطاء ---
void handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      throw ServerException(
        message: 'انتهت مهلة الاتصال، يرجى التحقق من شبكة الإنترنت.',
      );
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw ServerException(
            message: 'طلب غير صالح، يرجى مراجعة البيانات المدخلة.',
          );
        case 401:
          throw ServerException(message: 'بيانات الدخول غير صحيحة.');
        case 403:
          throw ServerException(message: 'ليس لديك صلاحية للوصول.');
        case 404:
          throw ServerException(
            message: 'تعذر العثور على الخادم، يرجى المحاولة لاحقًا.',
          );
        case 422:
          throw ServerException(message: 'البيانات المدخلة غير صحيحة.');
        case 500:
        case 502:
          throw ServerException(
            message: 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقًا.',
          );
        default:
          throw ServerException(message: 'حدث خطأ غير متوقع.');
      }
    case DioExceptionType.cancel:
      break;
    case DioExceptionType.unknown:
    case DioExceptionType.connectionError:
      throw ServerException(message: 'لا يوجد اتصال بالإنترنت.');
    case DioExceptionType.badCertificate:
      throw ServerException(message: 'شهادة الأمان غير صالحة.');
  }
}
