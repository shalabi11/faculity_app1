// lib/features/student/domain/repositories/student_repository.dart

import 'dart:io';
import 'package:faculity_app2/features/student/domain/entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  Future<void> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  });
  Future<void> deleteStudent({required int id});
  // --- أضفنا هذه الدالة ---
  Future<void> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  });
}
