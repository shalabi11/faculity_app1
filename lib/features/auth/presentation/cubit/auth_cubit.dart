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

  Future<void> loggedOut() async {
    try {
      await authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      // حتى لو فشل طلب الخروج من السيرفر، نسجل خروجه من التطبيق
      emit(Unauthenticated());
    }
  }
}
