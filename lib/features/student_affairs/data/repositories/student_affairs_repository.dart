// lib/features/student_affairs/data/repositories/student_affairs_repository.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';

abstract class StudentAffairsRepository {
  Future<Either<Failure, List<Student>>> getStudents();
  Future<Either<Failure, Unit>> addStudent({
    required Map<String, dynamic> studentData,
    File? image,
  });
  Future<Either<Failure, Unit>> updateStudent({
    required int id,
    required Map<String, dynamic> studentData,
  });
  Future<Either<Failure, Unit>> deleteStudent({required int id});
}
