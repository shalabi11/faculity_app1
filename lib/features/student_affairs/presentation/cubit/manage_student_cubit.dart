import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/student/domain/repositories/student_repository.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/add_student.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart'; // تأكد أن المسار صحيح

part 'manage_student_state.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  final AddStudent addStudentUseCase;

  AddStudentCubit({required this.addStudentUseCase})
    : super(AddStudentInitial());

  // --- هذه هي الدالة التي كانت مفقودة لديك ---
  Future<void> createStudent(StudentModel student, File? image) async {
    // 1. إصدار حالة التحميل لإظهار دائرة الانتظار في الواجهة
    emit(AddStudentLoading());

    // 2. استدعاء الـ UseCase لإرسال البيانات إلى الـ Repository
    final result = await addStudentUseCase(
      AddStudentParams(student: student, image: image),
    );

    // 3. التعامل مع النتيجة
    result.fold(
      (failure) => emit(
        const AddStudentError(
          message: 'فشل في إضافة الطالب. الرجاء المحاولة مرة أخرى.',
        ),
      ), // في حال الفشل
      (_) => emit(AddStudentSuccess()), // في حال النجاح
    );
  }
}
