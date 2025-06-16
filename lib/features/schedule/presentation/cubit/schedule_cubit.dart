import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/schedule_entry.dart';
import '../../domain/repositories/schedule_repository.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;

  ScheduleCubit({required this.repository}) : super(ScheduleInitial());

  Future<void> fetchTheorySchedule(String year) async {
    await _fetchSchedule(() => repository.getTheorySchedule(year));
  }

  Future<void> fetchLabSchedule(String group) async {
    await _fetchSchedule(() => repository.getLabSchedule(group));
  }

  Future<void> _fetchSchedule(
    Future<List<ScheduleEntry>> Function() getSchedule,
  ) async {
    try {
      emit(ScheduleLoading());
      final schedule = await getSchedule();
      emit(ScheduleLoaded(schedule));
    } on Exception catch (e) {
      emit(ScheduleError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
