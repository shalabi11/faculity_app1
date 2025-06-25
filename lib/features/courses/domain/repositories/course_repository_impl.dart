import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/courses/data/datasource/course_remote_data_source.dart';
import 'package:faculity_app2/features/courses/domain/entities/course.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;
  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Course>> getCourses() async {
    try {
      return await remoteDataSource.getCourses();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get courses: ${e.toString()}');
    }
  }

  @override
  Future<void> addCourse({required Map<String, dynamic> courseData}) async {
    try {
      await remoteDataSource.addCourse(courseData: courseData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add course: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  }) async {
    try {
      await remoteDataSource.updateCourse(id: id, courseData: courseData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update course: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCourse({required int id}) async {
    try {
      await remoteDataSource.deleteCourse(id: id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete course: ${e.toString()}');
    }
  }
}
