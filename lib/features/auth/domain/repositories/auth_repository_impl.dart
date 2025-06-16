// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login({required Map<String, dynamic> data}) async {
    try {
      final userModel = await remoteDataSource.login(data: data);
      return userModel;
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('حدث خطأ غير معروف، يرجى المحاولة مجددًا.');
    }
  }

  Future<void> register({required Map<String, dynamic> data}) async {
    try {
      await remoteDataSource.register(data: data);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('حدث خطأ غير معروف، يرجى المحاولة مجددًا.');
    }
  }
}
