// // lib/features/student/presentation/cubit/manage_student_cubit.dart

// import 'dart:io';
// import 'package:bloc/bloc.dart';

// import '../../data/models/student_model.dart';
// import '../../domain/repositories/student_repository.dart';

// part 'manage_student_state.dart';

// class ManageStudentCubit extends Cubit<ManageStudentState> {
//   final StudentRepository studentRepository;

//   ManageStudentCubit({
//     required this.studentRepository,
//     required Object addStudentUseCase,
//   }) : super(ManageStudentInitial());

//   Future<void> addStudent({
//     required Map<String, dynamic> studentData,
//     File? image,
//   }) async {
//     try {
//       emit(ManageStudentLoading());
//       await studentRepository.addStudent(
//         studentData: studentData,
//         image: image,
//       );
//       emit(ManageStudentSuccess('تمت إضافة الطالب بنجاح!'));
//     } on Exception catch (e) {
//       emit(ManageStudentFailure(e.toString().replaceAll('Exception: ', '')));
//     }
//   }

//   // --- أضفنا هذه الدالة ---
//   Future<void> updateStudent({
//     required int id,
//     required Map<String, dynamic> studentData,
//   }) async {
//     try {
//       emit(ManageStudentLoading());
//       await studentRepository.updateStudent(id: id, studentData: studentData);
//       emit(ManageStudentSuccess('تم تعديل بيانات الطالب بنجاح!'));
//     } on Exception catch (e) {
//       emit(ManageStudentFailure(e.toString().replaceAll('Exception: ', '')));
//     }
//   }

//   Future<void> deleteStudent({required int id}) async {
//     try {
//       emit(ManageStudentLoading());
//       await studentRepository.deleteStudent(id: id);
//       emit(ManageStudentSuccess('تم حذف الطالب بنجاح!'));
//     } on Exception catch (e) {
//       emit(ManageStudentFailure(e.toString().replaceAll('Exception: ', '')));
//     }
//   }

//   void createStudent(StudentModel newStudent, File? profileImage) {}
// }
