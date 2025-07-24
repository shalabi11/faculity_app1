import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/features/staff/domain/repositories/staff_repository.dart';
import 'package:faculity_app2/features/staff/presentation/cubit/staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  final StaffRepository staffRepository;

  StaffCubit({required this.staffRepository}) : super(StaffInitial());

  Future<void> fetchStaff() async {
    emit(StaffLoading());
    final failureOrStaff = await staffRepository.getAllStaff();
    failureOrStaff.fold(
      (failure) => emit(StaffError(message: "حاول لاحقا")),
      (staffList) => emit(StaffLoaded(staff: staffList)),
    );
  }
}
