import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

abstract class GradeEntryState extends Equatable {
  const GradeEntryState();
  @override
  List<Object> get props => [];
}

class GradeEntryInitial extends GradeEntryState {}

class GradeEntryLoading extends GradeEntryState {}

class GradeEntryLoaded extends GradeEntryState {
  final List<ExamResultEntity> students;
  const GradeEntryLoaded(this.students);
  @override
  List<Object> get props => [students];
}

class GradeEntryFailure extends GradeEntryState {
  final String message;
  const GradeEntryFailure(this.message);
  @override
  List<Object> get props => [message];
}

class GradeSaving extends GradeEntryState {}

class GradeSaveSuccess extends GradeEntryState {}
