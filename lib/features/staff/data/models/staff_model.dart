// lib/features/staff/data/models/staff_model.dart

import 'package:faculity_app2/features/staff/domain/entities/staff_entity.dart';

class StaffModel extends StaffEntity {
  const StaffModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.department,
    required super.motherName,
    required super.birthDate,
    required super.birthPlace,
    required super.academicDegree,
    required super.employmentDate,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      // ✨ --- التصحيح الرئيسي هنا --- ✨
      // استخدام int.tryParse للتعامل مع القيم الفارغة بأمان
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,

      fullName: json['full_name'] ?? 'غير متوفر',
      department: json['department'] ?? 'غير محدد',
      motherName: json['mother_name'] ?? 'غير متوفر',
      birthDate: json['birth_date'] ?? '',
      birthPlace: json['birth_place'] ?? 'غير متوفر',
      academicDegree: json['academic_degree'] ?? 'غير متوفر',
      employmentDate: json['employment_date'] ?? '',
    );
  }
}
