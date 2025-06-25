// lib/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/exam_hall_assignments/data/datasources/exam_hall_assignment_remote_data_source.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/entities/exam_hall_assignments.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository.dart';

class ExamHallAssignmentRepositoryImpl implements ExamHallAssignmentRepository {
  final ExamHallAssignmentRemoteDataSource remoteDataSource;

  ExamHallAssignmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> distributeHalls({required int examId}) async {
    try {
      await remoteDataSource.distributeHalls(examId: examId);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to distribute halls: ${e.toString()}');
    }
  }

  @override
  Future<List<ExamHallAssignment>> getHallAssignments({
    required int examId,
  }) async {
    try {
      return await remoteDataSource.getHallAssignments(examId: examId);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get assignments: ${e.toString()}');
    }
  }
}
