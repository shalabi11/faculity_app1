// lib/features/student/data/models/student_model.dart

import 'package:faculity_app2/features/student/domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.universityId,
    required super.fullName,
    required super.motherName,
    required super.birthDate,
    required super.birthPlace,
    required super.department,
    required super.highSchoolGpa,
    super.profileImageUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    // --- قمنا بتعديل هذه الدالة لتكون أكثر أمانًا ---
    return StudentModel(
      // نتعامل مع الـ id الرقمي بشكل آمن
      id: int.tryParse(json['id'].toString()) ?? 0,

      universityId: json['university_id'] ?? 'غير معروف',
      fullName: json['full_name'] ?? 'اسم غير متوفر',
      motherName: json['mother_name'] ?? 'اسم غير متوفر',
      birthDate: json['birth_date'] ?? 'تاريخ غير متوفر',
      birthPlace: json['birth_place'] ?? 'مكان غير متوفر',
      department: json['department'] ?? 'قسم غير محدد',

      // نتعامل مع المعدل الرقمي بشكل آمن
      highSchoolGpa: double.tryParse(json['high_school_gpa'].toString()) ?? 0.0,

      profileImageUrl: json['profile_image_url'],
    );
  }
}
