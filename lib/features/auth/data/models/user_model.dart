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
    // نفترض أن API تعيد هذه البيانات داخل كائن 'user'
    final userData = json['user'];
    return UserModel(
      id: userData['id'],
      name: userData['name'],
      email: userData['email'],
      role: userData['role'],
      token: json['token'],
      year: userData['year'],
      section: userData['section'],
    );
  }
}
