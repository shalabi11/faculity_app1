// lib/features/exams/domain/enteties/exam.dart

class Exam {
  final int id;
  final String courseName;
  final DateTime examDate;
  final String startTime;
  final String endTime;
  final String type;
  final String? targetYear; // <-- أضفنا هذا

  const Exam({
    required this.id,
    required this.courseName,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.targetYear, // <-- وأضفناه هنا
  });
}
