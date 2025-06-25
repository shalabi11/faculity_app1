// lib/features/users/data/models/app_user_model.dart

import 'package:faculity_app2/features/users/domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'مستخدم غير معروف',
      email: json['email'] ?? 'بريد إلكتروني غير معروف',
      role: json['role'] ?? 'دور غير معروف',
    );
  }
}
