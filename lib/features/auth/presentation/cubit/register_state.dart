part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

// ✨ تم التعديل هنا ليحتوي على بيانات المستخدم والوجهة
class RegisterSuccess extends RegisterState {
  final User user;
  final String target; // الوجهة التي سيتم الانتقال إليها (الدور المختار)

  RegisterSuccess(this.user, {required this.target});
}

class RegisterFailure extends RegisterState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}
