// lib/features/auth/data/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';

import '../models/user_model.dart';

// --- العقد ---
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required Map<String, dynamic> data});
  Future<void> register({required Map<String, dynamic> data});
}

// --- التنفيذ ---
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        'https://college-hub-production.up.railway.app/api/login',
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'خطأ غير متوقع. رمز الحالة: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      handleDioException(e);
      // This line is unreachable but required for type safety
      throw ServerException(message: 'خطأ في الشبكة');
    }
  }

  @override
  Future<void> register({required Map<String, dynamic> data}) async {
    try {
      // endpoint التسجيل من ملف Postman
      await dio.post(
        'https://college-hub-production.up.railway.app/api/register',
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      // التسجيل الناجح لا يرجع بيانات مستخدم في العادة، فقط استجابة نجاح
    } on DioException catch (e) {
      handleDioException(e);
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
