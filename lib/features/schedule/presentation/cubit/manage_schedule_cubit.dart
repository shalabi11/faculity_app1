import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

part 'manage_schedule_state.dart';

class ManageScheduleCubit extends Cubit<ManageScheduleState> {
  final ScheduleRepository repository;
  ManageScheduleCubit({required this.repository})
    : super(ManageScheduleInitial());

  Future<void> addSchedule({required Map<String, dynamic> scheduleData}) async {
    try {
      emit(ManageScheduleLoading());
      await repository.addSchedule(scheduleData);
      emit(ManageScheduleSuccess('تمت إضافة المحاضرة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteSchedule({required int id}) async {
    try {
      emit(ManageScheduleLoading());
      await repository.deleteSchedule(id);
      emit(ManageScheduleSuccess('تم حذف المحاضرة بنجاح!'));
    } on Exception catch (e) {
      emit(ManageScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
