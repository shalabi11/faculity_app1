import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

abstract class HeadOfExamsState extends Equatable {
  const HeadOfExamsState();
  @override
  List<Object> get props => [];
}

class HeadOfExamsInitial extends HeadOfExamsState {}

class HeadOfExamsLoading extends HeadOfExamsState {}

class HeadOfExamsLoaded extends HeadOfExamsState {
  final List<ExamEntity> exams;
  const HeadOfExamsLoaded(this.exams);
  @override
  List<Object> get props => [exams];
}

class HeadOfExamsFailure extends HeadOfExamsState {
  final String message;
  const HeadOfExamsFailure(this.message);
  @override
  List<Object> get props => [message];
}

class PublishingResults extends HeadOfExamsState {}

class PublishSuccess extends HeadOfExamsState {
  final String message;
  const PublishSuccess(this.message);
  @override
  List<Object> get props => [message];
}
