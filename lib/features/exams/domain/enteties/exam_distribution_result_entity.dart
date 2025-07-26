import 'package:equatable/equatable.dart';

class ExamDistributionResultEntity extends Equatable {
  final String studentName;
  final String universityId;
  final String classroomName;

  const ExamDistributionResultEntity({
    required this.studentName,
    required this.universityId,
    required this.classroomName,
  });

  @override
  List<Object?> get props => [studentName, universityId, classroomName];
}
