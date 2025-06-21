import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/student/data/datasource/student_remote_data_source.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student/domain/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Student>> getStudents() async {
    try {
      return await remoteDataSource.getStudents();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unknown error occurred');
    }
  }
}
