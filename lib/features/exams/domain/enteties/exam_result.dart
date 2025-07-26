import 'package:equatable/equatable.dart';

class ExamResultEntity extends Equatable {
  final int resultId;
  final int studentId;
  final String studentName;
  final double? score;

  const ExamResultEntity({
    required this.resultId,
    required this.studentId,
    required this.studentName,
    this.score,
  });

  @override
  List<Object?> get props => [resultId, studentId, studentName, score];
}
