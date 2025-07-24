import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseEntity>>> getAllCourses();
  Future<Either<Failure, Unit>> addCourse(Map<String, dynamic> courseData);
  Future<Either<Failure, Unit>> updateCourse(
    int id,
    Map<String, dynamic> courseData,
  );
  Future<Either<Failure, Unit>> deleteCourse(int id);
}
