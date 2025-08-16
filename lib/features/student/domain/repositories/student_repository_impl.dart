// // lib/features/student/domain/repositories/student_repository_impl.dart

// import 'dart:io';
// import 'package:faculity_app2/core/errors/exceptions.dart';
// import 'package:faculity_app2/features/student/data/datasource/student_remote_data_source.dart';
// import 'package:faculity_app2/features/student/domain/entities/student.dart';
// import 'package:faculity_app2/features/student/domain/repositories/student_repository.dart';

// class StudentRepositoryImpl implements StudentRepository {
//   final StudentRemoteDataSource remoteDataSource;

//   StudentRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<List<Student>> getStudents() async {
//     // ... (هذه الدالة تبقى كما هي)
//     try {
//       return await remoteDataSource.getStudents();
//     } on ServerException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception('حدث خطأ غير متوقع: ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> addStudent({
//     required Map<String, dynamic> studentData,
//     File? image,
//   }) async {
//     // ... (هذه الدالة تبقى كما هي)
//     try {
//       await remoteDataSource.addStudent(studentData: studentData, image: image);
//     } on ServerException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception('فشل إضافة الطالب: ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> deleteStudent({required int id}) async {
//     // ... (هذه الدالة تبقى كما هي)
//     try {
//       await remoteDataSource.deleteStudent(id: id);
//     } on ServerException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception('فشل حذف الطالب: ${e.toString()}');
//     }
//   }

//   // --- وهذه هي تفاصيل تنفيذها ---
//   @override
//   Future<void> updateStudent({
//     required int id,
//     required Map<String, dynamic> studentData,
//   }) async {
//     try {
//       await remoteDataSource.updateStudent(id: id, studentData: studentData);
//     } on ServerException catch (e) {
//       throw Exception(e.message);
//     } catch (e) {
//       throw Exception('فشل تحديث الطالب: ${e.toString()}');
//     }
//   }
// }
