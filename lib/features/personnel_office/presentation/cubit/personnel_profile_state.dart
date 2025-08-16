// lib/features/personnel_office/presentation/cubit/personnel_profile_state.dart

part of 'personnel_profile_cubit.dart';

abstract class PersonnelProfileState extends Equatable {
  const PersonnelProfileState();

  @override
  List<Object> get props => [];
}

class PersonnelProfileInitial extends PersonnelProfileState {}

class PersonnelProfileLoading extends PersonnelProfileState {}

class PersonnelProfileSuccess extends PersonnelProfileState {
  final StaffEntity staffMember;
  const PersonnelProfileSuccess(this.staffMember);

  @override
  List<Object> get props => [staffMember];
}

class PersonnelProfileFailure extends PersonnelProfileState {
  final String message;
  const PersonnelProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}
