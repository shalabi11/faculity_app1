import 'package:dio/dio.dart';
import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/auth/data/models/user_model.dart';
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
      // ===========================================
      //  هذا هو التعديل: اطبع الخطأ الفعلي هنا
      // ===========================================
      print('====> ROOT CAUSE OF LOGIN ERROR: $e');

      // ثم ارمِ رسالتنا العامة للمستخدم
      throw Exception('حدث خطأ غير معروف، يرجى المحاولة مجددًا.');
    }
  }

  @override
  Future<void> register({required Map<String, dynamic> data}) async {
    try {
      await remoteDataSource.register(data: data);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      print('====> ROOT CAUSE OF REGISTER ERROR: $e');
      throw Exception('حدث خطأ غير معروف، يرجى المحاولة مجددًا.');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred during logout');
    }
  }

  @override
  Future<User> getUserProfile() async {
    try {
      return await remoteDataSource.getUserProfile();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Could not fetch user profile');
    }
  }
}
