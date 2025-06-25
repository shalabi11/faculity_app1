import 'package:faculity_app2/features/classrooms/domain/entities/classroom.dart';

abstract class ClassroomRepository {
  Future<List<Classroom>> getClassrooms();
  Future<void> addClassroom({required Map<String, dynamic> classroomData});
  Future<void> updateClassroom({
    required int id,
    required Map<String, dynamic> classroomData,
  });
  Future<void> deleteClassroom({required int id});
}
