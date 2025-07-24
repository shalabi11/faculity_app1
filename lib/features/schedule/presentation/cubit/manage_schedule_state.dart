import 'package:equatable/equatable.dart';

abstract class ManageScheduleState extends Equatable {
  const ManageScheduleState();
  @override
  List<Object> get props => [];
}

class ManageScheduleInitial extends ManageScheduleState {}

class ManageScheduleLoading extends ManageScheduleState {}

class ManageScheduleSuccess extends ManageScheduleState {
  final String message;
  const ManageScheduleSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class ManageScheduleFailure extends ManageScheduleState {
  final String message;
  const ManageScheduleFailure(this.message);
  @override
  List<Object> get props => [message];
}
