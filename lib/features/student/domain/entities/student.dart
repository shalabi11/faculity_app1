// lib/features/student/domain/entities/student.dart

class Student {
  final int id;
  final String universityId;
  final String fullName;
  final String motherName;
  final String birthDate;
  final String birthPlace; // <-- تم إصلاح الخطأ الإملائي هنا
  final String department;
  final double highSchoolGpa;
  final String? profileImageUrl;

  const Student({
    required this.id,
    required this.universityId,
    required this.fullName,
    required this.motherName,
    required this.birthDate,
    required this.birthPlace, // <-- تم إصلاح الخطأ الإملائي هنا
    required this.department,
    required this.highSchoolGpa,
    this.profileImageUrl,
  });
}
