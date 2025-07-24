// import 'package:bloc/bloc.dart';
// import 'package:faculity_app2/features/main_screen/presentation/cubit/home_state.dart';
// import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
// import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';

// class HomeCubit extends Cubit<HomeState> {
//   final ScheduleRepository scheduleRepository;

//   HomeCubit({required this.scheduleRepository}) : super(HomeInitial());

//   Future<void> fetchTodaysSchedule({
//     required String? year,
//     required String? group,
//     required String? section,
//   }) async {
//     if (year == null || group == null || section == null) {
//       emit(
//         TodaysScheduleError(
//           'لا يمكن جلب الجدول. بيانات الطالب (السنة أو الفئة أو الشعبة) غير متوفرة.',
//         ),
//       );
//       return;
//     }

//     try {
//       emit(TodaysScheduleLoading());

//       // جلب كلا الجدولين في نفس الوقت
//       final results = await Future.wait([
//         scheduleRepository.getTheorySchedule(year),
//         scheduleRepository.getLabSchedule(group, section),
//       ]);

//       final theoryResult = results[0];
//       final labResult = results[1];

//       List<ScheduleEntity> theoryEntries = [];
//       List<ScheduleEntity> labEntries = [];
//       String? errorMessage;

//       // --- هذا هو الجزء الذي تم تصحيحه ---
//       // معالجة نتيجة الجدول النظري
//       theoryResult.fold(
//         (failure) => errorMessage = failure.message,
//         (schedule) => theoryEntries = schedule,
//       );

//       // معالجة نتيجة الجدول العملي
//       labResult.fold((failure) {
//         // إذا كان هناك خطأ سابق، أضف هذا الخطأ إليه
//         errorMessage = (errorMessage ?? '') + '\n' + failure.message;
//       }, (schedule) => labEntries = schedule);

//       // إذا حدث أي خطأ، قم بإصدار حالة الفشل
//       if (errorMessage != null) {
//         emit(TodaysScheduleError(errorMessage!));
//         return;
//       }

//       // دمج القائمتين
//       final List<ScheduleEntity> allEntries = [...theoryEntries, ...labEntries];

//       final String today = _getTodayInArabic();

//       final todaysEntries =
//           allEntries.where((entry) => entry.day == today).toList();

//       todaysEntries.sort((a, b) => a.startTime.compareTo(b.startTime));

//       emit(TodaysScheduleLoaded(todaysEntries));
//     } on Exception catch (e) {
//       emit(TodaysScheduleError(e.toString().replaceFirst('Exception: ', '')));
//     }
//   }

//   String _getTodayInArabic() {
//     final dayOfWeek = DateTime.now().weekday;
//     switch (dayOfWeek) {
//       case DateTime.saturday:
//         return 'السبت';
//       case DateTime.sunday:
//         return 'الأحد';
//       case DateTime.monday:
//         return 'الإثنين';
//       case DateTime.tuesday:
//         return 'الثلاثاء';
//       case DateTime.wednesday:
//         return 'الأربعاء';
//       case DateTime.thursday:
//         return 'الخميس';
//       case DateTime.friday:
//         return 'الجمعة';
//       default:
//         return '';
//     }
//   }
// }
