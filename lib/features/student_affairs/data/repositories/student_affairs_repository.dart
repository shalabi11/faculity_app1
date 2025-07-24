import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/student_dashboard_entity.dart';
import '../../../../core/errors/failures.dart';

abstract class StudentAffairsRepository {
  Future<Either<Failure, StudentDashboardEntity>> getStudentDashboardData();
  Future<Either<Failure, Unit>> addStudent(StudentModel student, File? image);
}
