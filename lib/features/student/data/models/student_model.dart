import '../../domain/entities/student.dart';

class StudentModel extends Student {
  StudentModel({
    required super.id,
    required super.universityId,
    required super.fullName,
    super.motherName,
    super.birthDate,
    super.department,
    super.profileImage,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? 0,
      universityId: json['university_id'] ?? '',
      fullName: json['full_name'] ?? 'اسم غير معروف',
      motherName: json['mother_name'],
      birthDate: json['birth_date'],
      department: json['department'],
      profileImage: json['profile_image'],
    );
  }
}
