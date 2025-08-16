// lib/features/teachers/presentation/cubit/teacher_job/teacher_profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';
// ✨ 1. استيراد مكتبة collection للوصول إلى firstWhereOrNull
import 'package:collection/collection.dart';

part 'teacher_profile_state.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final TeacherRepository teacherRepository;
  TeacherProfileCubit({required this.teacherRepository})
    : super(TeacherProfileInitial());

  Future<void> fetchTeacherDetails(int teacherId) async {
    try {
      emit(TeacherProfileLoading());
      final allTeachers = await teacherRepository.getTeachers();

      // ✨ 2. استخدام firstWhereOrNull بدلاً من firstWhere
      // هذه الدالة تعيد null إذا لم تجد عنصراً مطابقاً بدلاً من إطلاق خطأ
      final teacher = allTeachers.firstWhereOrNull((t) => t.id == teacherId);

      // ✨ 3. التحقق من النتيجة
      if (teacher != null) {
        // إذا تم العثور على المدرس، أرسل بياناته للواجهة
        emit(TeacherProfileSuccess(teacher));
      } else {
        // إذا لم يتم العثور عليه، أرسل حالة فشل مع رسالة واضحة
        emit(const TeacherProfileFailure('لم يتم العثور على بيانات المدرس.'));
      }
    } on Exception catch (e) {
      emit(TeacherProfileFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
