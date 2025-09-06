import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(LoginInitial());

  // ✨ 1. تعديل الدالة لتقبل القسم كقيمة اختيارية
  Future<void> login({
    required Map<String, dynamic> data,
    String? department,
  }) async {
    emit(LoginLoading());

    try {
      var user = await authRepository.login(data: data);

      // ✨ 2. حقن القسم يدوياً في بيانات المستخدم
      if (department != null) {
        user = user.copyWith(department: department);
      }

      sl<AuthCubit>().loggedIn(user);

      // نستخدم الدور الأصلي من الواجهة للتوجيه الصحيح
      emit(LoginSuccess(user, target: data['original_role'] ?? user.role));
    } on ServerException catch (e) {
      emit(LoginFailure(e.message ?? 'حدث خطأ من الخادم'));
    } on Exception catch (e) {
      emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
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
