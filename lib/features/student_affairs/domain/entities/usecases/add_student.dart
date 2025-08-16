// lib/features/student_affairs/domain/entities/usecases/add_student.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/core/errors/failures.dart';
import 'package:faculity_app2/core/usecases/usecase.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

// هذا هو الكلاس الأساسي للحالة
class AddStudent implements UseCase<Unit, AddStudentParams> {
  final StudentAffairsRepository repository;

  AddStudent(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddStudentParams params) async {
    // ✨ --- تم التعديل هنا --- ✨
    // الآن نقوم بتمرير البيانات كـ Map مباشرة
    return await repository.addStudent(
      studentData: params.studentData,
      image: params.image,
    );
  }
}

// هذا الكلاس لتمرير البيانات إلى الـ UseCase
class AddStudentParams extends Equatable {
  // ✨ --- تم التعديل هنا --- ✨
  // أصبحنا نمرر البيانات كـ Map بدلاً من StudentModel
  final Map<String, dynamic> studentData;
  final File? image;

  const AddStudentParams({required this.studentData, this.image});

  @override
  List<Object?> get props => [studentData, image];
}
