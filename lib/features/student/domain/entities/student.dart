import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final int id;
  final String universityId;
  final String fullName;
  final String motherName;
  final String birthDate;
  final String birthPlace;
  final String department;
  final String year; // أضفنا السنة
  final double highSchoolGpa;
  final String? profileImageUrl;

  const Student({
    required this.id,
    required this.universityId,
    required this.fullName,
    required this.motherName,
    required this.birthDate,
    required this.birthPlace,
    required this.department,
    required this.year,
    required this.highSchoolGpa,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    universityId,
    fullName,
    motherName,
    birthDate,
    birthPlace,
    department,
    year,
    highSchoolGpa,
    profileImageUrl,
  ];
}
