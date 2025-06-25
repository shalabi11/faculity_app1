// lib/features/courses/domain/entities/course.dart

class Course {
  final int id;
  final String name;
  final String department;
  final String year;

  const Course({
    required this.id,
    required this.name,
    required this.department,
    required this.year,
  });
}
