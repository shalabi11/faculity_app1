// Enum لتتبع حالة كل جزء من الشاشة على حدة
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

enum ExamsStatus { initial, loading, loaded, error }

class ExamsState {
  // --- حالة جدول الامتحانات ---
  final ExamsStatus examsStatus;
  final List<Exam> exams;

  // --- حالة نتائج الطالب ---
  final ExamsStatus resultsStatus;
  final List<ExamResult> results;

  // --- رسالة الخطأ (مشتركة) ---
  final String? errorMessage;

  const ExamsState({
    this.examsStatus = ExamsStatus.initial,
    this.exams = const [],
    this.resultsStatus = ExamsStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  // دالة مساعدة لنسخ الحالة مع تغيير بعض القيم
  ExamsState copyWith({
    ExamsStatus? examsStatus,
    List<Exam>? exams,
    ExamsStatus? resultsStatus,
    List<ExamResult>? results,
    String? errorMessage,
  }) {
    return ExamsState(
      examsStatus: examsStatus ?? this.examsStatus,
      exams: exams ?? this.exams,
      resultsStatus: resultsStatus ?? this.resultsStatus,
      results: results ?? this.results,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
