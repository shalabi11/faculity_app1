import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;

  ScheduleCubit({required this.repository}) : super(ScheduleInitial());

  Future<void> fetchTheorySchedule({required String year}) async {
    try {
      emit(ScheduleLoading());
      final schedule = await repository.getTheorySchedule(year);
      emit(ScheduleSuccess(schedule as List<ScheduleEntity>));
    } on Exception catch (e) {
      emit(ScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  // The requested change is applied here
  Future<void> fetchLabSchedule({
    required String group,
    required String section, // The new section parameter
  }) async {
    try {
      emit(ScheduleLoading());
      // Pass the section parameter to the repository
      final schedule = await repository.getLabSchedule(group, section);
      emit(ScheduleSuccess(schedule));
    } on Exception catch (e) {
      emit(ScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
