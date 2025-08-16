// lib/features/student_affairs/presentation/cubit/manage_student_cubit.dart

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
// ✨ تم حذف استيراد غير ضروري وتعديل المسار ليكون متوافقاً
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

part 'manage_student_state.dart';

class ManageStudentCubit extends Cubit<ManageStudentState> {
  final StudentAffairsRepository studentAffairsRepository;

  ManageStudentCubit({required this.studentAffairsRepository})
    : super(ManageStudentInitial());

  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  }) async {
    emit(ManageStudentLoading());
    final result = await studentAffairsRepository.addStudent(
      studentData: studentData,
      image: image,
    );
    result.fold((failure) {
      String message = 'فشل في إضافة الطالب';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(ManageStudentFailure(message));
    }, (_) => emit(ManageStudentSuccess('تمت إضافة الطالب بنجاح!')));
  }

  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  }) async {
    emit(ManageStudentLoading());
    final result = await studentAffairsRepository.updateStudent(
      id: id,
      studentData: studentData,
    );
    result.fold((failure) {
      String message = 'فشل في تعديل الطالب';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(ManageStudentFailure(message));
    }, (_) => emit(ManageStudentSuccess('تم تعديل الطالب بنجاح!')));
  }

  Future<void> deleteStudent({required int id}) async {
    emit(ManageStudentLoading());
    final result = await studentAffairsRepository.deleteStudent(id: id);
    result.fold((failure) {
      String message = 'فشل في حذف الطالب';
      if (failure is ServerFailure) {
        message = failure.message;
      }
      emit(ManageStudentFailure(message));
    }, (_) => emit(ManageStudentSuccess('تم حذف الطالب بنجاح!')));
  }
}
