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
    super.universityId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData =
        (json['user'] is Map<String, dynamic> ? json['user'] : json)
            as Map<String, dynamic>? ??
        {};

    return UserModel(
      universityId: json['university_id']?.toString(),
      id: int.tryParse(userData['id']?.toString() ?? '0') ?? 0,
      name: userData['name'] ?? 'مستخدم غير معروف',
      email: userData['email'] ?? '',
      role: userData['role'] ?? 'student',
      token: json['token'],
      year: userData['year'],
      section: userData['group'], // API يرسل 'group' وليس 'section'
    );
  }
}
