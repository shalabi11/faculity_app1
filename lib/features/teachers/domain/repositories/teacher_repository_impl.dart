// lib/features/teachers/domain/repositories/teacher_repository_impl.dart

import 'package:faculity_app2/core/errors/exceptions.dart';
import 'package:faculity_app2/features/schedule/data/models/schedule_entry_model.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/teachers/data/datasources/teacher_remote_data_source.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  final TeacherRemoteDataSource remoteDataSource;

  TeacherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TeacherEntity>> getTeachers() async {
    try {
      return await remoteDataSource.getTeachers();
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get teachers: ${e.toString()}');
    }
  }

  @override
  Future<List<ScheduleEntryModel>> getTeacherSchedule(int teacherId) async {
    try {
      return await remoteDataSource.getTeacherSchedule(teacherId);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to get teacher schedule: ${e.toString()}');
    }
  }

  // --- تم تعديل معالجة الأخطاء هنا ---
  @override
  Future<void> addTeacher({required Map<String, dynamic> teacherData}) async {
    try {
      await remoteDataSource.addTeacher(teacherData: teacherData);
    } on ServerException catch (e) {
      // الآن سنقرأ الرسالة التفصيلية من الخطأ
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to add teacher: ${e.toString()}');
    }
  }

  // --- وتم تعديلها هنا أيضًا ---
  @override
  Future<void> updateTeacher({
    required int id,
    required Map<String, dynamic> teacherData,
  }) async {
    try {
      await remoteDataSource.updateTeacher(id: id, teacherData: teacherData);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to update teacher: ${e.toString()}');
    }
  }

  // --- وهنا أيضًا للتوحيد ---
  @override
  Future<void> deleteTeacher({required int id}) async {
    try {
      await remoteDataSource.deleteTeacher(id: id);
    } on ServerException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to delete teacher: ${e.toString()}');
    }
  }
}
