// lib/core/errors/error_handler.dart

import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';

void handleDioException(DioException e) {
  String errorMessage;

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      errorMessage =
          'انتهت مهلة الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت.';
      break;
    case DioExceptionType.badResponse:
      // هنا يمكنك التعامل مع رموز الحالة المختلفة (e.g., 400, 401, 403, 404, 500)
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;
      errorMessage = _handleBadResponse(statusCode, responseData);
      break;
    case DioExceptionType.cancel:
      errorMessage = 'تم إلغاء الطلب إلى الخادم.';
      break;
    case DioExceptionType.connectionError:
      errorMessage = 'فشل الاتصال بالخادم، تأكد من اتصالك بالشبكة.';
      break;
    case DioExceptionType.unknown:
    default:
      errorMessage = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.';
      break;
  }

  // throw ServerException with the custom message
  throw ServerException(message: errorMessage);
}

String _handleBadResponse(int? statusCode, dynamic responseData) {
  String message = 'حدث خطأ ما.';
  // محاولة قراءة رسالة الخطأ من الخادم
  if (responseData is Map<String, dynamic> &&
      responseData.containsKey('message')) {
    message = responseData['message'];
  }

  switch (statusCode) {
    case 400: // Bad Request
      return 'طلب غير صالح. $message';
    case 401: // Unauthorized
      return 'غير مصرح لك بالوصول، قد تكون كلمة المرور أو البريد الإلكتروني غير صحيحة.';
    case 403: // Forbidden
      return 'ليس لديك الصلاحية للقيام بهذه العملية.';
    case 404: // Not Found
      return 'المورد المطلوب غير موجود.';
    case 422: // Unprocessable Entity (Validation errors)
      // Laravel often returns validation errors under 'errors' key
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('errors')) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        // Take the first validation error message
        return errors.values.first[0];
      }
      return 'البيانات المدخلة غير صالحة. $message';
    case 500: // Internal Server Error
    case 502: // Bad Gateway
      return 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى لاحقاً.';
    default:
      return 'حدث خطأ أثناء الاتصال بالخادم (رمز الحالة: $statusCode).';
  }
}
