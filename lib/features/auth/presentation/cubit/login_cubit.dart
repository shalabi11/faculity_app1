// lib/features/auth/presentation/cubit/login_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  Future<void> login({required Map<String, dynamic> data}) async {
    // --- نقاط التفتيش تبدأ هنا ---
    print('✅ [Login] 1. Starting login process for role: ${data['role']}...');

    emit(LoginLoading());
    print('✅ [Login] 2. Emitted Loading State.');

    try {
      print('✅ [Login] 3. Calling repository with data...');
      // سنقوم بالتحقق من هذا السطر
      final user = await authRepository.login(data: data);
      print('✅ [Login] 4. Login successful! User name: ${user.name}');

      // سنقوم بالتحقق من هذا السطر
      sl<AuthCubit>().loggedIn(user);
      print('✅ [Login] 5. AuthCubit has been notified.');

      emit(LoginSuccess(user));
      print(
        '✅ [Login] 6. Emitted Success State. Navigation should happen now.',
      );
    } on Exception catch (e) {
      // --- نقطة تفتيش مهمة جداً للأخطاء ---
      print('❌ [Login] An exception was caught: $e');
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(LoginFailure(errorMessage));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(LogoutSuccess());
    } on Exception catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
