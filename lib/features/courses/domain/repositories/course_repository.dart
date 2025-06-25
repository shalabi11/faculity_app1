import 'package:faculity_app2/features/courses/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<Course>> getCourses();
  Future<void> addCourse({required Map<String, dynamic> courseData});
  Future<void> updateCourse({
    required int id,
    required Map<String, dynamic> courseData,
  });
  Future<void> deleteCourse({required int id});
}
