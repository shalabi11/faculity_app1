// lib/features/classrooms/domain/entities/classroom.dart

class Classroom {
  final int id;
  final String name;
  final String type;
  // أضفنا الحقول التالية
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Classroom({
    required this.id,
    required this.name,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });
}
