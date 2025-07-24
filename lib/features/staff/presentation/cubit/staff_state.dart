import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';

abstract class StaffState extends Equatable {
  const StaffState();
  @override
  List<Object> get props => [];
}

class StaffInitial extends StaffState {}

class StaffLoading extends StaffState {}

class StaffLoaded extends StaffState {
  final List<StaffEntity> staff;
  const StaffLoaded({required this.staff});
  @override
  List<Object> get props => [staff];
}

class StaffError extends StaffState {
  final String message;
  const StaffError({required this.message});
  @override
  List<Object> get props => [message];
}
