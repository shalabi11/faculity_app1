import 'package:internet_connection_checker/internet_connection_checker.dart';

// هذا هو العقد (Abstract Class) الذي يعتمد عليه الـ Repository
// هذا يسمح لنا بتغيير طريقة التحقق من الإنترنت لاحقاً دون تعديل الـ Repository
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// هذا هو التنفيذ الفعلي للكلاس باستخدام الحزمة التي أضفناها
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
