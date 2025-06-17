import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/exams/data/datasource/exams_remote_data_source.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam.dart';
import 'package:faculity_app2/features/exams/domain/enteties/exam_result.dart';

import '../../domain/repositories/exams_repository.dart';

class ExamsRepositoryImpl implements ExamsRepository {
  final ExamsRemoteDataSource remoteDataSource;

  ExamsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Exam>> getExams() async {
    try {
      return await remoteDataSource.getExams();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }

  @override
  Future<List<ExamResult>> getStudentResults(int studentId) async {
    try {
      return await remoteDataSource.getStudentResults(studentId);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }
}
