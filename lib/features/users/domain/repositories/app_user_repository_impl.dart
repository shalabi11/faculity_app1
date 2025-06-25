// lib/features/users/domain/repositories/app_user_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/users/data/datasources/app_user_remote_data_source.dart';
import 'package:faculity_app2/features/users/domain/entities/app_user.dart';
import 'package:faculity_app2/features/users/domain/repositories/app_user_repository.dart';

class AppUserRepositoryImpl implements AppUserRepository {
  final AppUserRemoteDataSource remoteDataSource;

  AppUserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AppUser>> getUsers() async {
    try {
      return await remoteDataSource.getUsers();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }
}
