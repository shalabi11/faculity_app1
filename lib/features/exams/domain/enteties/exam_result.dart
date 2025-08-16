// lib/features/exams/domain/enteties/exam_result.dart
import 'package:equatable/equatable.dart';

class ExamResultEntity extends Equatable {
  final int resultId;
  final int studentId;
  final String studentName;
  final double? score;
  final String courseName; // ✨ تم إضافة اسم المادة هنا

  const ExamResultEntity({
    required this.resultId,
    required this.studentId,
    required this.studentName,
    this.score,
    required this.courseName, // ✨ تم التحديث هنا
  });

  @override
  List<Object?> get props => [
    resultId,
    studentId,
    studentName,
    score,
    courseName,
  ];
}
