import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents();
  // لاحقًا سنضيف دوال الإضافة والتعديل والحذف هنا
}
