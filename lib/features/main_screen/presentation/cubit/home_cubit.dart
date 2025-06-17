import 'package:bloc/bloc.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/home_state.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final ScheduleRepository scheduleRepository;

  HomeCubit({required this.scheduleRepository}) : super(HomeInitial());

  // --- التعديل هنا: جعل المتغيرات تقبل القيمة الفارغة (nullable) ---
  Future<void> fetchTodaysSchedule({
    required String? year,
    required String? group,
  }) async {
    // التأكد من أن بيانات الطالب موجودة قبل المتابعة
    if (year == null || group == null) {
      emit(
        TodaysScheduleError(
          'لا يمكن جلب الجدول. بيانات الطالب (السنة أو الفئة) غير متوفرة.',
        ),
      );
      return;
    }

    try {
      emit(TodaysScheduleLoading());

      final results = await Future.wait([
        scheduleRepository.getTheorySchedule(year),
        scheduleRepository.getLabSchedule(group),
      ]);

      final List<ScheduleEntry> allEntries = [...results[0], ...results[1]];
      final String today = _getTodayInArabic();

      final todaysEntries =
          allEntries.where((entry) => entry.day == today).toList();

      todaysEntries.sort((a, b) => a.startTime.compareTo(b.startTime));

      emit(TodaysScheduleLoaded(todaysEntries));
    } on Exception catch (e) {
      emit(TodaysScheduleError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  String _getTodayInArabic() {
    final dayOfWeek = DateTime.now().weekday;
    switch (dayOfWeek) {
      case DateTime.saturday:
        return 'السبت';
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الإثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      default:
        return '';
    }
  }
}
