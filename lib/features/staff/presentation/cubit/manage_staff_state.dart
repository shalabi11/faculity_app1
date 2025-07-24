import 'package:equatable/equatable.dart';

abstract class ManageStaffState extends Equatable {
  const ManageStaffState();
  @override
  List<Object> get props => [];
}

class ManageStaffInitial extends ManageStaffState {}

class ManageStaffLoading extends ManageStaffState {}

class ManageStaffSuccess extends ManageStaffState {}

class ManageStaffFailure extends ManageStaffState {
  final String message;
  const ManageStaffFailure({required this.message});
  @override
  List<Object> get props => [message];
}
