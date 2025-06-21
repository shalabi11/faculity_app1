import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
    required String role,
    String? token,
    String? year,
    String? section,
  }) : super(
         id: id,
         name: name,
         email: email,
         role: role,
         token: token,
         year: year,
         section: section,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // --- هذا هو التعديل الأهم ---
    // 1. التحقق مما إذا كانت بيانات المستخدم موجودة داخل كائن 'user'
    // 2. إذا لم تكن كذلك، نستخدم الخريطة الرئيسية مباشرةً
    final userData =
        (json['user'] is Map<String, dynamic> ? json['user'] : json)
            as Map<String, dynamic>? ??
        {};

    return UserModel(
      // استخدام '??' لتوفير قيمة افتراضية آمنة في حال كانت القيمة null
      id: userData['id'] ?? 0,
      name: userData['name'] ?? 'مستخدم غير معروف',
      email: userData['email'] ?? '',
      role:
          userData['role'] ??
          'student', // القيمة الافتراضية في حال لم يتم العثور على الدور
      token: json['token'],
      year: userData['year'],
      section: userData['section'],
    );
  }
}
