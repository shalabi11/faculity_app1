// lib/features/auth/presentation/cubit/login_cubit.dart

import 'package:bloc/bloc.dart';
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
      emit(LoginSuccess(user));
    } on Exception catch (e) {
      // إزالة "Exception: " من بداية رسالة الخطأ
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(LoginFailure(errorMessage));
    }
  }
}
