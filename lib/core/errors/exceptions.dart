// lib/core/error/exceptions.dart

// استثناء عام للخادم
class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

// يمكننا إنشاء استثناءات أكثر تحديدًا إذا أردنا
// class UnauthorizedException extends ServerException { ... }
