// lib/features/exams/domain/repositories/exams_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/exams/data/datasource/exams_remote_data_source.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart'; // <-- أضفنا هذا
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';

class ExamsRepositoryImpl implements ExamsRepository {
  final ExamsRemoteDataSource remoteDataSource;
  ExamsRepositoryImpl({required this.remoteDataSource});

  // --- دوال الامتحانات تبقى كما هي ---
  @override
  Future<List<Exam>> getExams() async {
    try {
      return await remoteDataSource.getExams();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get exams: ${e.toString()}');
    }
  }

  @override
  Future<void> addExam({required Map<String, dynamic> examData}) async {
    try {
      await remoteDataSource.addExam(examData: examData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add exam: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExam({
    required int id,
    required Map<String, dynamic> examData,
  }) async {
    try {
      await remoteDataSource.updateExam(id: id, examData: examData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update exam: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteExam({required int id}) async {
    try {
      await remoteDataSource.deleteExam(id: id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete exam: ${e.toString()}');
    }
  }

  // --- وهذه هي تفاصيل تنفيذ الدالة الجديدة ---
  @override
  Future<List<ExamResult>> getStudentResults({required int studentId}) async {
    try {
      return await remoteDataSource.getStudentResults(studentId: studentId);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get student results: ${e.toString()}');
    }
  }
}
