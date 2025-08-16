// lib/features/teachers/presentation/cubit/teacher_job/teacher_schedule_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
// ✨ 1. استيراد مستودع الجداول
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';

part 'teacher_schedule_state.dart';

class TeacherScheduleCubit extends Cubit<TeacherScheduleState> {
  final TeacherRepository teacherRepository;
  // ✨ 2. إضافة مستودع الجداول هنا
  final ScheduleRepository scheduleRepository;

  TeacherScheduleCubit({
    required this.teacherRepository,
    // ✨ 3. تحديث الـ constructor
    required this.scheduleRepository,
  }) : super(TeacherScheduleInitial());

  Future<void> fetchTeacherSchedule(int teacherId, String teacherName) async {
    emit(TeacherScheduleLoading());

    try {
      const years = ['الأولى', 'الثانية', 'الثالثة', 'الرابعة', 'الخامسة'];
      const groups = ['A', 'B'];
      const sections = ['A', 'B'];

      List<ScheduleEntity> allSchedules = [];

      for (var year in years) {
        // ✨ 4. استخدام مستودع الجداول لجلب البيانات
        final theoryResult = await scheduleRepository.getTheorySchedule(year);
        theoryResult.fold(
          (failure) => null,
          (schedule) => allSchedules.addAll(schedule),
        );
      }

      for (var group in groups) {
        for (var section in sections) {
          // ✨ 5. استخدام مستودع الجداول لجلب البيانات
          final labResult = await scheduleRepository.getLabSchedule(
            group,
            section,
          );
          labResult.fold(
            (failure) => null,
            (schedule) => allSchedules.addAll(schedule),
          );
        }
      }

      final teacherSchedules =
          allSchedules
              .where((entry) => entry.teacherName == teacherName)
              .toList();

      final uniqueSchedules = teacherSchedules.toSet().toList();
      uniqueSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

      emit(TeacherScheduleSuccess(uniqueSchedules));
    } on Exception catch (e) {
      emit(TeacherScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
