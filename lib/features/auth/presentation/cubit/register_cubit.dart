import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;

  RegisterCubit({required this.authRepository}) : super(RegisterInitial());

  Future<void> register({required Map<String, dynamic> data}) async {
    try {
      emit(RegisterLoading());
      await authRepository.register(data: data);
      emit(RegisterSuccess('تم إنشاء الحساب بنجاح! يمكنك الآن تسجيل الدخول.'));
    } on Exception catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      emit(RegisterFailure(errorMessage));
    }
  }
}
