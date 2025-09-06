// lib/features/auth/presentation/cubit/register_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/domain/entities/user.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(RegisterInitial());

  Future<void> register({required Map<String, dynamic> data}) async {
    emit(RegisterLoading());
    try {
      // 1. إنشاء الحساب
      await authRepository.register(data: data);

      // ✨ --- 2. تحديث منطق تسجيل الدخول التلقائي --- ✨
      final role = data['role'];
      Map<String, dynamic> loginData = {
        'password': data['password'],
        'role': role,
      };

      if (role == 'student') {
        loginData['university_id'] = data['university_id'];
      } else if (role == 'teacher') {
        loginData['employee_id'] = data['employee_id'];
      } else {
        // للموظفين وبقية الأدوار التي تستخدم البريد الإلكتروني
        loginData['email'] = data['email'];
      }

      // 3. تسجيل الدخول للحصول على التوكن وبيانات المستخدم
      final user = await authRepository.login(data: loginData);

      // 4. إخبار AuthCubit العام بتسجيل الدخول
      sl<AuthCubit>().loggedIn(user);

      // 5. إصدار حالة النجاح
      emit(RegisterSuccess(user, target: user.role));
    } on ServerException catch (e, s) {
      print("❗️ ServerException in RegisterCubit: ${e.message}");
      print(s);
      emit(RegisterFailure(e.message ?? 'حدث خطأ من الخادم'));
    } catch (e, s) {
      print("❗️ Generic Exception in RegisterCubit: $e");
      print(s);
      emit(RegisterFailure(e.toString()));
    }
  }
}
