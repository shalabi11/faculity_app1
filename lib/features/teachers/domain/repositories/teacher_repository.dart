import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';

abstract class TeacherRepository {
  Future<List<TeacherEntity>> getTeachers();
  Future<void> addTeacher({required Map<String, dynamic> teacherData});
  Future<void> updateTeacher({
    required int id,
    required Map<String, dynamic> teacherData,
  });
  Future<void> deleteTeacher({required int id});
}
