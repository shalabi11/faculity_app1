import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';

import 'package:meta/meta.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  Future<void> appStarted() async {
    try {
      // محاولة جلب بيانات المستخدم بناءً على التوكن المخزن
      final user = await authRepository.getUserProfile();
      emit(Authenticated(user));
    } catch (e) {
      // إذا فشل (لا يوجد توكن أو التوكن غير صالح)، نعتبر المستخدم غير مسجل دخوله
      emit(Unauthenticated());
    }
  }

  void loggedIn(User user) {
    emit(Authenticated(user));
  }

  // lib/features/auth/presentation/cubit/auth_cubit.dart

  // ... (داخل كلاس AuthCubit)

  Future<void> logout() async {
    try {
      // 1. إصدار حالة التحميل أولاً
      emit(AuthLoading());
      // تأخير بسيط لرؤية المؤشر (اختياري، جيد للعرض)
      await Future.delayed(const Duration(milliseconds: 500));

      // 2. استدعاء دالة الخروج من المستودع
      await authRepository.logout();

      // 3. إصدار حالة "غير مصادق عليه" بعد النجاح
      emit(Unauthenticated());
    } on Exception catch (_) {
      // 4. حتى في حال حدوث خطأ، اعتبر المستخدم قد خرج
      emit(Unauthenticated());
    }
  }
}
