import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/classrooms/data/datasource/classroom_remote_data_source.dart';
import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';
import 'package:faculity_app2/features/classrooms/domain/repositories/classroom_repository.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomRemoteDataSource remoteDataSource;
  ClassroomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Classroom>> getClassrooms() async {
    try {
      return await remoteDataSource.getClassrooms();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get classrooms: ${e.toString()}');
    }
  }

  @override
  Future<void> addClassroom({
    required Map<String, dynamic> classroomData,
  }) async {
    try {
      await remoteDataSource.addClassroom(classroomData: classroomData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add classroom: ${e.toString()}');
    }
  }

  @override
  Future<void> updateClassroom({
    required int id,
    required Map<String, dynamic> classroomData,
  }) async {
    try {
      await remoteDataSource.updateClassroom(
        id: id,
        classroomData: classroomData,
      );
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update classroom: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteClassroom({required int id}) async {
    try {
      await remoteDataSource.deleteClassroom(id: id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete classroom: ${e.toString()}');
    }
  }
}
