import 'package:dio/dio.dart';
import 'package:faculity_app2/core/utils/constant.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required Map<String, dynamic> data});
  Future<void> register({required Map<String, dynamic> data});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> login({required Map<String, dynamic> data}) async {
    try {
      final response = await dio.post(
        '$baseUrl/api/login', // <-- استخدام المتغير الجديد
        data: data,
        options: Options(headers: {'Accept': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'خطأ غير متوقع');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw ServerException(message: 'خطأ في الشبكة');
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
