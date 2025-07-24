import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.department,
    required super.year,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      name: json['name'] ?? 'اسم غير متوفر',
      department: json['department'] ?? 'قسم غير محدد',
      year: json['year'] ?? 'سنة غير محددة',
    );
  }
}
