// lib/features/auth/presentation/cubit/login_state.dart
part of 'login_cubit.dart'; // سنقوم بإنشاء هذا الملف لاحقًا

@immutable
abstract class LoginState {}

// الحالة الأولية - لا شيء يحدث
class LoginInitial extends LoginState {}

// حالة التحميل - عند الضغط على زر الدخول وبانتظار الرد
class LoginLoading extends LoginState {}

// حالة النجاح - عند نجاح تسجيل الدخول
// في ملف login_state.dart
class LoginSuccess extends LoginState {
  final User user;
  final String target;

  LoginSuccess(this.user, {required this.target});
}

// حالة الفشل - عند حدوث خطأ
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

class LogoutSuccess extends LoginState {}
