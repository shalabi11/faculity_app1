import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(RegisterInitial());

  Future<void> register({required Map<String, dynamic> data}) async {
    emit(RegisterLoading());
    try {
      // ✨ --- المنطق الجديد هنا --- ✨

      // 1. تحديد الدور الذي سيتم إرساله للـ API (للتسجيل)
      final selectedRole = data['role'];
      String apiRole = selectedRole;
      if (selectedRole != 'student') {
        apiRole = 'admin';
      }

      final registerData = {...data, 'role': apiRole};

      // 2. محاولة إنشاء الحساب الجديد
      await authRepository.register(data: registerData);

      // 3. بعد نجاح التسجيل، قم بتسجيل الدخول تلقائياً لجلب بيانات المستخدم والتوكن
      final loginData = {
        'role': apiRole,
        'email': data['email'],
        'password': data['password'],
      };
      if (data.containsKey('university_id')) {
        loginData['university_id'] = data['university_id'];
      }
      if (data.containsKey('employee_id')) {
        loginData['employee_id'] = data['employee_id'];
      }

      final user = await authRepository.login(data: loginData);

      // 4. إخبار الـ AuthCubit بحالة المصادقة الجديدة
      sl<AuthCubit>().loggedIn(user);

      // 5. إصدار حالة النجاح مع بيانات المستخدم والدور المختار كوجهة
      emit(RegisterSuccess(user, target: selectedRole));
    } on Exception catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(RegisterFailure(errorMessage));
    }
  }
}
