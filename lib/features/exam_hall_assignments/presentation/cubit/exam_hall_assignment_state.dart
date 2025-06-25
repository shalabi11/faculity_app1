import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';

abstract class ExamHallAssignmentState {}

class ExamHallAssignmentInitial extends ExamHallAssignmentState {}

class ExamHallAssignmentLoading extends ExamHallAssignmentState {}

// حالة خاصة لنجاح عملية التوزيع نفسها
class ExamHallAssignmentDistributionSuccess extends ExamHallAssignmentState {}

// حالة خاصة لنجاح جلب النتائج
class ExamHallAssignmentLoadSuccess extends ExamHallAssignmentState {
  final List<ExamHallAssignment> assignments;
  ExamHallAssignmentLoadSuccess(this.assignments);
}

class ExamHallAssignmentFailure extends ExamHallAssignmentState {
  final String message;
  ExamHallAssignmentFailure(this.message);
}
