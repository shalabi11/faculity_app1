import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/users/domain/entities/app_user.dart';
import 'package:faculity_app2/features/users/domain/repositories/app_user_repository.dart';
import 'package:faculity_app2/features/users/presentation/cubit/app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final AppUserRepository repository;

  AppUserCubit({required this.repository}) : super(AppUserInitial());

  Future<void> fetchUsers() async {
    try {
      emit(AppUserLoading());
      final users = await repository.getUsers();
      emit(AppUserSuccess(users));
    } on Exception catch (e) {
      emit(AppUserFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
