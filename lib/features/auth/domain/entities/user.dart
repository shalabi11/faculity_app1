// lib/features/auth/domain/entities/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? token; // التوكن مهم جدًا للحفاظ عليه

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });
}
