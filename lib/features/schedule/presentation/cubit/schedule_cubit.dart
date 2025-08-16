// lib/features/schedule/presentation/cubit/schedule_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;

  ScheduleCubit({required this.repository}) : super(ScheduleInitial());

  Future<void> fetchTheorySchedule({required String year}) async {
    emit(ScheduleLoading());
    final failureOrSchedule = await repository.getTheorySchedule(year);

    failureOrSchedule.fold((failure) {
      // ✨ --- تم التعديل هنا --- ✨
      // الآن يتم استخلاص الرسالة بشكل صحيح
      String message = 'فشل في جلب البيانات';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(ScheduleFailure(message));
    }, (schedule) => emit(ScheduleSuccess(schedule)));
  }

  Future<void> fetchLabSchedule({
    required String group,
    required String section,
  }) async {
    emit(ScheduleLoading());
    final failureOrSchedule = await repository.getLabSchedule(group, section);
    failureOrSchedule.fold((failure) {
      String message = 'فشل في جلب البيانات';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(ScheduleFailure(message));
    }, (schedule) => emit(ScheduleSuccess(schedule)));
  }

  // lib/features/schedule/presentation/cubit/schedule_cubit.dart

  // ✨ --- أضف هذه الدالة الجديدة --- ✨
  Future<void> fetchStudentWeeklySchedule({
    required String? year,
    required String? section, // This is the student's group/section
  }) async {
    emit(ScheduleLoading());
    try {
      // إذا لم يكن لدى الطالب سنة دراسية، فلا يمكن أن يكون لديه جدول
      if (year == null || year.isEmpty) {
        emit(ScheduleSuccess([])); // أرسل قائمة فارغة
        return;
      }

      List<ScheduleEntity> allEntries = [];
      String? errorMessage;

      // 1. جلب الجدول النظري
      final theoryResult = await repository.getTheorySchedule(year);
      theoryResult.fold((failure) {
        if (failure is ServerFailure) errorMessage = failure.message;
      }, (schedule) => allEntries.addAll(schedule));

      // 2. جلب الجدول العملي فقط إذا كان الطالب مسجلاً في شعبة
      if (section != null && section.isNotEmpty) {
        // نفترض أن شعبة الطالب تستخدم لكلا پارامترات المجموعة والشعبة
        final labResult = await repository.getLabSchedule(section, section);
        labResult.fold((failure) {
          if (failure is ServerFailure) {
            errorMessage = (errorMessage ?? '') + '\n' + failure.message;
          }
        }, (schedule) => allEntries.addAll(schedule));
      }

      if (errorMessage != null) {
        emit(ScheduleFailure(errorMessage.toString()));
        return;
      }

      // إزالة أي تكرار في المحاضرات
      final uniqueEntries = allEntries.toSet().toList();
      emit(ScheduleSuccess(uniqueEntries));
    } on Exception catch (e) {
      emit(ScheduleFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
