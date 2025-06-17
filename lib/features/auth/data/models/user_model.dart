import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.token,
    super.year,
    super.section,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // التحقق من وجود كائن 'user' وتوفير خريطة فارغة كقيمة افتراضية
    final userData = json['user'] as Map<String, dynamic>? ?? {};

    return UserModel(
      // استخدام '??' لتوفير قيمة افتراضية آمنة في حال كانت القيمة null
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'مستخدم غير معروف',
      email: userData['email'] ?? '',
      role: userData['role'] ?? 'student',
      token: json['token'], // هذا قابل ليكون null بالفعل
      year: userData['year'], // هذا قابل ليكون null بالفعل
      section: userData['section'], // هذا قابل ليكون null بالفعل
    );
  }
}
