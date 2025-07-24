import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// خطأ عام من الخادم (الآن يحمل رسالة)
class ServerFailure extends Failure {
  final String message;

  ServerFailure({required this.message});

  @override
  List<Object> get props => [message];
}

// خطأ في الاتصال بالإنترنت
class OfflineFailure extends Failure {}
