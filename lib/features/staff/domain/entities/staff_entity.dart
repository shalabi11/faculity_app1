// lib/features/staff/domain/entities/staff_entity.dart

import 'package:equatable/equatable.dart';

class StaffEntity extends Equatable {
  final int id;
  // ✨ 1. إضافة userId
  final int userId;
  final String fullName;
  final String motherName;
  final String birthDate;
  final String birthPlace;
  final String academicDegree;
  final String department;
  final String employmentDate;

  const StaffEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.motherName,
    required this.birthDate,
    required this.birthPlace,
    required this.academicDegree,
    required this.department,
    required this.employmentDate,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    fullName,
    motherName,
    birthDate,
    birthPlace,
    academicDegree,
    department,
    employmentDate,
  ];
}
