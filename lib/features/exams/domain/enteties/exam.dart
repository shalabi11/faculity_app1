import 'package:equatable/equatable.dart';

class ExamEntity extends Equatable {
  final int id;
  final String courseName;
  final String examDate; // استخدام String أفضل هنا للتعامل مع صيغة YYYY-MM-DD
  final String startTime;
  final String endTime;
  final String type;
  final String? targetYear;
  final int courseId; // <-- أضف هذا السطر

  const ExamEntity({
    required this.id,
    required this.courseName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.courseId,
    this.targetYear,
  });

  @override
  // هذه القائمة تخبر Equatable أي الحقول يجب مقارنتها
  List<Object?> get props => [
    id,
    courseName,
    examDate,
    startTime,
    endTime,
    type,
    targetYear,
    courseId,
  ];
}
