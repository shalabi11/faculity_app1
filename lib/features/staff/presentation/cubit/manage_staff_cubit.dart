import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/staff/domain/repositories/staff_repository.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/manage_staff_state.dart';

class ManageStaffCubit extends Cubit<ManageStaffState> {
  final StaffRepository staffRepository;

  ManageStaffCubit({required this.staffRepository})
    : super(ManageStaffInitial());

  Future<void> addStaff(Map<String, dynamic> staffData) async {
    emit(ManageStaffLoading());
    final result = await staffRepository.addStaff(staffData);
    result.fold(
      (failure) => emit(ManageStaffFailure(message: "حاول لاحقا")),
      (_) => emit(ManageStaffSuccess()),
    );
  }

  Future<void> deleteStaff(int staffId) async {
    emit(ManageStaffLoading());
    final result = await staffRepository.deleteStaff(staffId);
    result.fold(
      (failure) => emit(ManageStaffFailure(message: "حاول لاحقا")),
      (_) => emit(ManageStaffSuccess()),
    );
  }

  Future<void> updateStaff(int staffId, Map<String, dynamic> staffData) async {
    emit(ManageStaffLoading());
    final result = await staffRepository.updateStaff(staffId, staffData);
    result.fold(
      (failure) => emit(ManageStaffFailure(message: "حاول لاحقا")),
      (_) => emit(ManageStaffSuccess()),
    );
  }

  // دوال الحذف والتعديل ستضاف هنا لاحقاً
}
