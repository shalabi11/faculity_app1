import 'package:faculity_app2/features/users/domain/entities/app_user.dart';

abstract class AppUserState {}

class AppUserInitial extends AppUserState {}

class AppUserLoading extends AppUserState {}

class AppUserSuccess extends AppUserState {
  final List<AppUser> users;
  AppUserSuccess(this.users);
}

class AppUserFailure extends AppUserState {
  final String message;
  AppUserFailure(this.message);
}
