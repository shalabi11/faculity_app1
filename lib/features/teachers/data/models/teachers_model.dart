import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';

class TeacherModel extends TeacherEntity {
  const TeacherModel({
    required super.id,
    required super.fullName,
    required super.motherName,
    required super.birthDate,
    required super.birthPlace,
    required super.academicDegree,
    required super.degreeSource,
    required super.department,
    required super.position,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['full_name'] ?? 'اسم غير متوفر',
      motherName: json['mother_name'] ?? 'اسم غير متوفر',
      birthDate: json['birth_date'] ?? 'تاريخ غير متوفر',
      birthPlace: json['birth_place'] ?? 'مكان غير متوفر',
      academicDegree: json['academic_degree'] ?? 'غير محدد',
      degreeSource: json['degree_source'] ?? 'غير محدد',
      department: json['department'] ?? 'قسم غير محدد',
      position: json['position'] ?? 'منصب غير محدد',
    );
  }
}
