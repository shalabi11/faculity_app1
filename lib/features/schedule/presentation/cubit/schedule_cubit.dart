// lib/features/schedule/presentation/cubit/schedule_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;

  ScheduleCubit({required this.repository}) : super(ScheduleInitial());

  Future<void> fetchTheorySchedule({required String year}) async {
    try {
      emit(ScheduleLoading());
      final schedule = await repository.getTheorySchedule(year);
      emit(ScheduleSuccess(schedule));
    } on Exception catch (e) {
      emit(ScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> fetchLabSchedule({
    required String group,
    required String section,
  }) async {
    try {
      emit(ScheduleLoading());
      final schedule = await repository.getLabSchedule(group);
      emit(ScheduleSuccess(schedule));
    } on Exception catch (e) {
      emit(ScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
