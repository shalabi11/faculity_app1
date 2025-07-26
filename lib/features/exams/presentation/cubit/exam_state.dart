import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

abstract class ExamState extends Equatable {
  const ExamState();
  @override
  List<Object> get props => [];
}

class ExamInitial extends ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final List<ExamEntity> exams;
  const ExamLoaded({required this.exams});
  @override
  List<Object> get props => [exams];
}

class ExamError extends ExamState {
  final String message;
  const ExamError({required this.message});
  @override
  List<Object> get props => [message];
}
