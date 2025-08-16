// lib/features/personnel_office/presentation/cubit/personnel_profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';
import 'package:faculity_app2/features/staff/domain/repositories/staff_repository.dart';

part 'personnel_profile_state.dart';

class PersonnelProfileCubit extends Cubit<PersonnelProfileState> {
  final StaffRepository staffRepository;
  PersonnelProfileCubit({required this.staffRepository})
    : super(PersonnelProfileInitial());

  Future<void> fetchPersonnelDetails(int userId) async {
    try {
      emit(PersonnelProfileLoading());
      final staffListResult = await staffRepository.getAllStaff();

      staffListResult.fold(
        (failure) => emit(
          PersonnelProfileFailure('Failed to load staff list: $failure'),
        ),
        (staffList) {
          final staffMember = staffList.firstWhereOrNull((s) => s.id == userId);
          if (staffMember != null) {
            emit(PersonnelProfileSuccess(staffMember));
          } else {
            emit(
              const PersonnelProfileFailure('لم يتم العثور على بيانات الموظف.'),
            );
          }
        },
      );
    } on Exception catch (e) {
      emit(PersonnelProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
