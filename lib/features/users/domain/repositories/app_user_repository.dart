// lib/features/users/domain/repositories/app_user_repository.dart

import 'package:faculity_app2/features/users/domain/entities/app_user.dart';

abstract class AppUserRepository {
  Future<List<AppUser>> getUsers();
}
