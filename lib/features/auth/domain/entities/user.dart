class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? token;
  // --- حقول مضافة ---
  final String? year;
  final String? section;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
    this.year,
    this.section,
  });
}
