// lib/features/teachers/domain/entities/teacher.dart

class Teacher {
  final int id;
  final String fullName;
  final String motherName;
  final String birthDate;
  final String birthPlace;
  final String academicDegree;
  final String degreeSource;
  final String department;
  final String position;

  const Teacher({
    required this.id,
    required this.fullName,
    required this.motherName,
    required this.birthDate,
    required this.birthPlace,
    required this.academicDegree,
    required this.degreeSource,
    required this.department,
    required this.position,
  });
}
