import 'package:equatable/equatable.dart';

// تمت إضافة extends Equatable لجعل مقارنة الكائنات أسهل وأكثر فعالية
class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role; // تم تعديله ليكون final لمزيد من الأمان
  final String? token;
  final String? year;
  final String? section;
  final String? universityId;

  // تم تعديل الـ constructor ليناسب final role
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
    this.year,
    this.section,
    this.universityId,
  });

  // --- ✅ هذا هو التعديل المطلوب ✅ ---
  // الآن، الدالة تتحقق من قيمة حقل role بشكل صحيح
  bool get isAdmin => role == 'admin';

  // props ضرورية لعمل Equatable بشكل صحيح
  @override
  List<Object?> get props => [id, name, email, role, token, year, section];
}
