import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? token;
  final String? year;
  final String? section;
  final String? universityId;
  final String? department;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
    this.year,
    this.section,
    this.universityId,
    this.department,
  });

  // ✨ --- تمت إضافة دالة copyWith هنا --- ✨
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? token,
    String? year,
    String? section,
    String? universityId,
    String? department,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      token: token ?? this.token,
      year: year ?? this.year,
      section: section ?? this.section,
      universityId: universityId ?? this.universityId,
      department: department ?? this.department,
    );
  }

  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    token,
    year,
    section,
    universityId,
    department,
  ];
}
