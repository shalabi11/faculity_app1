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
    try {
      emit(LoginLoading());
      final user = await authRepository.login(data: data);
      sl<AuthCubit>().loggedIn(user);
      emit(LoginSuccess(user));
    } on Exception catch (e) {
      print('====> ERROR in LoginCubit: $e'); // <-- أضف هذا
      // إزالة "Exception: " من بداية رسالة الخطأ
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(LoginFailure(errorMessage));
    }
  }

  Future<void> logout() async {
    try {
      // لا نحتاج لحالة تحميل هنا لأنها عملية سريعة
      await authRepository.logout();
      emit(LogoutSuccess()); // حالة جديدة يجب إضافتها
    } on Exception catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
