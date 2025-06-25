part of 'manage_exam_cubit.dart';

abstract class ManageExamState {}

class ManageExamInitial extends ManageExamState {}

class ManageExamLoading extends ManageExamState {}

class ManageExamSuccess extends ManageExamState {
  final String message;
  ManageExamSuccess(this.message);
}

class ManageExamFailure extends ManageExamState {
  final String message;
  ManageExamFailure(this.message);
}
