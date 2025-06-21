class Student {
  final int id;
  final String universityId;
  final String fullName;
  final String? motherName;
  final String? birthDate;
  final String? department;
  final String? profileImage;

  Student({
    required this.id,
    required this.universityId,
    required this.fullName,
    this.motherName,
    this.birthDate,
    this.department,
    this.profileImage,
  });
}
