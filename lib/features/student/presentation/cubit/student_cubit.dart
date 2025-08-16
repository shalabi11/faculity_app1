// // lib/features/student/presentation/cubit/student_cubit.dart

// import 'package:bloc/bloc.dart';
// import 'package:faculity_app2/features/student/domain/entities/student.dart';
// import 'package:faculity_app2/features/student/domain/repositories/student_repository.dart';

// part 'student_state.dart';

// class StudentCubit extends Cubit<StudentState> {
//   final StudentRepository studentRepository;

//   StudentCubit({required this.studentRepository}) : super(StudentInitial());

//   Future<void> fetchStudents() async {
//     try {
//       emit(StudentLoading());
//       final students = await studentRepository.getStudents();
//       emit(StudentSuccess(students));
//     } on Exception catch (e) {
//       emit(StudentFailure(e.toString().replaceAll('Exception: ', '')));
//     }
//   }
// }
