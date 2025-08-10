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
    print('✅ [Login] 1. Starting login process for role: ${data['role']}...');
    emit(LoginLoading());

    try {
      final user = await authRepository.login(data: data);
      sl<AuthCubit>().loggedIn(user);

      // منطق تحديد الوجهة حسب الدور
      if (user.role == 'student') {
        emit(LoginSuccess(user, target: 'student'));
      } else {
        emit(LoginSuccess(user, target: data['role']));
      }
    } on Exception catch (e) {
      emit(LoginFailure(e.toString()));
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
