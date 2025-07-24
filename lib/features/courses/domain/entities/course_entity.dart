import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final int id;
  final String name;
  final String department;
  final String year;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.department,
    required this.year,
  });

  @override
  // هذه القائمة تخبر Equatable أي الحقول يجب مقارنتها
  List<Object?> get props => [id, name, department, year];
}
