import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_state.dart';

class ManageScheduleCubit extends Cubit<ManageScheduleState> {
  final ScheduleRepository repository;

  ManageScheduleCubit({required this.repository})
    : super(ManageScheduleInitial());

  Future<void> addSchedule({required Map<String, dynamic> scheduleData}) async {
    emit(ManageScheduleLoading());
    final result = await repository.addSchedule(scheduleData);
    result.fold(
      (failure) => emit(ManageScheduleFailure(failure.toString())),
      (_) => emit(const ManageScheduleSuccess('تمت إضافة الجلسة بنجاح!')),
    );
  }

  Future<void> deleteSchedule({required int id}) async {
    emit(ManageScheduleLoading());
    final result = await repository.deleteSchedule(id);
    result.fold(
      (failure) => emit(ManageScheduleFailure(failure.toString())),
      (_) => emit(const ManageScheduleSuccess('تم حذف الجلسة بنجاح!')),
    );
  }

  Future<void> updateSchedule({
    required int id,
    required Map<String, dynamic> scheduleData,
  }) async {
    emit(ManageScheduleLoading());
    final result = await repository.updateSchedule(id, scheduleData);
    result.fold(
      (failure) => emit(ManageScheduleFailure(failure.toString())),
      (_) => emit(const ManageScheduleSuccess('تم تعديل الجلسة بنجاح!')),
    );
  }

  // دوال الحذف والتعديل ستضاف هنا لاحقاً
}
