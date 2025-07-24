import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart'; // تأكد من صحة المسار
import 'package:faculity_app2/core/usecases/usecase.dart'; // تأكد من صحة المسار
import 'package:faculity_app2/features/student/data/models/student_model.dart';

import '../../../data/repositories/student_affairs_repository.dart'; // تأكد من صحة المسار

// هذا هو الكلاس الأساسي للحالة
class AddStudent implements UseCase<Unit, AddStudentParams> {
  final StudentAffairsRepository repository;

  AddStudent(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddStudentParams params) async {
    return await repository.addStudent(params.student, params.image);
  }
}

// هذا الكلاس لتمرير البيانات إلى الـ UseCase
class AddStudentParams extends Equatable {
  final StudentModel student;
  final File? image;

  const AddStudentParams({required this.student, this.image});

  @override
  List<Object?> get props => [student, image];
}
