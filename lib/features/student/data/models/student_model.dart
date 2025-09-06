// lib/features/student/data/models/student_model.dart

import '../../domain/entities/student.dart';

class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.universityId,
    required super.fullName,
    required super.motherName,
    required super.birthDate,
    required super.birthPlace,
    required super.department,
    required super.year,
    required super.highSchoolGpa,
    super.profileImageUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      universityId: json['university_id'] ?? 'غير متوفر',
      fullName: json['full_name'] ?? 'اسم غير متوفر',
      motherName: json['mother_name'] ?? 'غير متوفر',
      birthDate: json['birth_date'] ?? 'غير متوفر',
      birthPlace: json['birth_place'] ?? 'غير متوفر',
      department: json['department'] ?? 'غير محدد',
      year: json['year']?.toString() ?? 'غير محدد',
      highSchoolGpa: double.tryParse(json['high_school_gpa'].toString()) ?? 0.0,
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'full_name': fullName,
      'mother_name': motherName,
      'birth_date': birthDate,
      'birth_place': birthPlace,
      'department': department,
      'year': year,
      'high_school_gpa': highSchoolGpa,
      'profile_image_url': profileImageUrl,
    };
  }
}
