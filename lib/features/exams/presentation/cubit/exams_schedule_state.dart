// lib/features/exams/presentation/cubit/exams_schedule_state.dart

import 'package:equatable/equatable.dart';
// تأكد من أن هذا هو المسار الصحيح لكلاس Exam
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';

// الكلاس الأساسي الذي سترث منه جميع الحالات الأخرى
abstract class ExamsScheduleState extends Equatable {
  const ExamsScheduleState();

  @override
  List<Object> get props => [];
}

// الحالة الأولية (عندما لا يتم عمل أي شيء بعد)
class ExamsScheduleInitial extends ExamsScheduleState {}

// **هذه هي الحالة التي كانت مفقودة**
// حالة جلب البيانات من الشبكة (التحميل)
class ExamsScheduleLoading extends ExamsScheduleState {}

// حالة نجاح جلب البيانات
class ExamsScheduleSuccess extends ExamsScheduleState {
  final List<Exam> exams;

  const ExamsScheduleSuccess(this.exams);

  @override
  List<Object> get props => [exams];
}

// حالة فشل جلب البيانات
class ExamsScheduleFailure extends ExamsScheduleState {
  final String message;

  const ExamsScheduleFailure(this.message);

  @override
  List<Object> get props => [message];
}
