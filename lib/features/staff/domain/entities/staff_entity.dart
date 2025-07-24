import 'package:equatable/equatable.dart';

class StaffEntity extends Equatable {
  final int id;
  final String fullName;
  final String motherName;
  final String birthDate;
  final String birthPlace;
  final String academicDegree;
  final String department;
  final String employmentDate;

  const StaffEntity({
    required this.id,
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
    fullName,
    motherName,
    birthDate,
    birthPlace,
    academicDegree,
    department,
    employmentDate,
  ];
}
