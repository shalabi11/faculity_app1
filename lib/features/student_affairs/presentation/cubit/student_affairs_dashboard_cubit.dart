import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';

// ✨ 1. حذف استيراد AppUserRepository لأنه لم نعد بحاجته
// import 'package:faculity_app2/features/users/domain/repositories/app_user_repository.dart';

part 'student_affairs_dashboard_state.dart';

class StudentAffairsDashboardCubit extends Cubit<StudentAffairsDashboardState> {
  final StudentAffairsRepository studentAffairsRepository;
  // ✨ 2. حذف AppUserRepository من هنا أيضاً
  // final AppUserRepository appUserRepository;

  StudentAffairsDashboardCubit({
    required this.studentAffairsRepository,
    // required this.appUserRepository,
  }) : super(StudentAffairsDashboardInitial());

  Future<void> fetchDashboardData() async {
    emit(StudentAffairsDashboardLoading());
    try {
      // ✨ 3. الآن نجلب قائمة الطلاب فقط
      final studentsResult = await studentAffairsRepository.getStudents();

      studentsResult.fold(
        (failure) => emit(StudentAffairsDashboardFailure(failure.toString())),
        (students) {
          // تجميع الطلاب المسجلين حسب السنة
          final Map<String, List<Student>> studentsByYear = {};
          for (var student in students) {
            (studentsByYear[student.year] ??= []).add(student);
          }

          // ✨ 4. إرسال البيانات المتاحة فقط إلى الواجهة
          emit(
            StudentAffairsDashboardSuccess(
              studentsByYear: studentsByYear,
              // لقد قمنا بإزالة pendingStudentsCount من الحالة
            ),
          );
        },
      );
    } on Exception catch (e) {
      emit(StudentAffairsDashboardFailure(e.toString()));
    }
  }
}
