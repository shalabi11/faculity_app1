import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_distribution_result_entity.dart';

abstract class ExamDistributionState extends Equatable {
  const ExamDistributionState();
  @override
  List<Object> get props => [];
}

class ExamDistributionInitial extends ExamDistributionState {}

class ExamDistributionLoading extends ExamDistributionState {}

class ExamDistributionSuccess extends ExamDistributionState {
  final List<ExamDistributionResultEntity> results;
  const ExamDistributionSuccess(this.results);
  @override
  List<Object> get props => [results];
}

class ExamDistributionFailure extends ExamDistributionState {
  final String message;
  const ExamDistributionFailure(this.message);
  @override
  List<Object> get props => [message];
}
