// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required Map<String, dynamic> data});
  Future<void> register({required Map<String, dynamic> data});
}
