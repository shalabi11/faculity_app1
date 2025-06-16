// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
    required String role,
    String? token,
  }) : super(id: id, name: name, email: email, role: role, token: token);

  // دالة لتحويل الـ JSON القادم من الـ API إلى كائن UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // استجابة الـ API تحتوي على كائن 'user' وتوكن
      id: json['user']['id'],
      name: json['user']['name'],
      email: json['user']['email'],
      role: json['user']['role'],
      token: json['token'],
    );
  }
}
