// lib/core/services/service_locator.dart
import 'package:dio/dio.dart';
import 'package:faculity_app2/core/platform/network_info.dart';
import 'package:faculity_app2/core/theme/cubit/theme_cubit.dart';
import 'package:faculity_app2/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:faculity_app2/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:faculity_app2/features/announcements/domain/repositories/announcement_repository_impl.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/anage_announcements_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:faculity_app2/features/classrooms/data/datasource/classroom_remote_data_source.dart';
import 'package:faculity_app2/features/classrooms/domain/repositories/classroom_repository.dart';
import 'package:faculity_app2/features/classrooms/domain/repositories/classroom_repository_impl.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/classroom_cubit.dart';
import 'package:faculity_app2/features/classrooms/presentation/cubit/manage_classroom_cubit.dart';
import 'package:faculity_app2/features/courses/data/datasource/course_remote_data_source.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository.dart';
import 'package:faculity_app2/features/courses/domain/repositories/course_repository_impl.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/course_cubit.dart';
import 'package:faculity_app2/features/courses/presentation/cubit/manage_course_cubit.dart';
import 'package:faculity_app2/features/exam_hall_assignments/data/datasources/exam_hall_assignment_remote_data_source.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository.dart';
import 'package:faculity_app2/features/exam_hall_assignments/domain/repositories/exam_hall_assignment_repository_impl.dart';
import 'package:faculity_app2/features/exam_hall_assignments/presentation/cubit/exam_hall_assignment_cubit.dart';
import 'package:faculity_app2/features/exams/data/datasource/exams_remote_data_source.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository_impl.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/manage_exam_cubit.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/student_exam_results_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/home_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/main_screen_cubit.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository_impl.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/manage_schedule_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';
import 'package:faculity_app2/features/student/data/datasource/student_remote_data_source.dart';
import 'package:faculity_app2/features/student/domain/repositories/student_repository.dart';
import 'package:faculity_app2/features/student/domain/repositories/student_repository_impl.dart';
import 'package:faculity_app2/features/student/presentation/cubit/manage_student_cubit.dart';
import 'package:faculity_app2/features/student/presentation/cubit/student_cubit.dart';
import 'package:faculity_app2/features/student_affairs/data/datasource/student_affairs_remote_data_source.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository_impl.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/add_student.dart';
import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/get_student_dashboard_data.dart';
import 'package:faculity_app2/features/teachers/data/datasources/teacher_remote_data_source.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository.dart';
import 'package:faculity_app2/features/teachers/domain/repositories/teacher_repository_impl.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/manage_teacher_cubit.dart';
import 'package:faculity_app2/features/teachers/presentation/cubit/teacher_cubit.dart';
import 'package:faculity_app2/features/users/data/datasources/app_user_remote_data_source.dart';
import 'package:faculity_app2/features/users/domain/repositories/app_user_repository.dart';
import 'package:faculity_app2/features/users/domain/repositories/app_user_repository_impl.dart';
import 'package:faculity_app2/features/users/presentation/cubit/app_user_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- استيراد ملفات "شؤون الطلاب" (الميزة الجديدة) ---

import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart'
    as affairs; // <-- استخدام alias لتجنب التعارض
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
// --- نهاية الاستيرادات الجديدة ---

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await sl.reset(dispose: false);

  // =====================
  //  External & Core
  // =====================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // =====================
  //  Theme
  // =====================
  sl.registerFactory<ThemeCubit>(() => ThemeCubit(sharedPreferences: sl()));

  // =====================
  //  Features
  // =====================

  // --- 🌟 ميزة شؤون الطلاب (القسم الجديد والمُنظَّم) 🌟 ---
  sl.registerFactory(() => StudentAffairsCubit(getStudentDashboardData: sl()));
  sl.registerFactory(() => affairs.AddStudentCubit(addStudentUseCase: sl()));
  sl.registerLazySingleton(() => GetStudentDashboardData(sl()));
  sl.registerLazySingleton(() => AddStudent(sl()));
  sl.registerLazySingleton<StudentAffairsRepository>(
    () =>
        StudentAffairsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<StudentAffairsRemoteDataSource>(
    () => StudentAffairsRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  // --- نهاية قسم شؤون الطلاب ---

  // -- Auth Feature --
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(authRepository: sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(authRepository: sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(authRepository: sl()));

  // -- Main Screen & Home Features --
  sl.registerFactory<MainScreenCubit>(() => MainScreenCubit());
  sl.registerFactory<HomeCubit>(() => HomeCubit(scheduleRepository: sl()));

  // -- Schedule Feature --
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<ScheduleCubit>(() => ScheduleCubit(repository: sl()));
  sl.registerFactory<ManageScheduleCubit>(
    () => ManageScheduleCubit(repository: sl()),
  );

  // -- Announcement Feature --
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(
      dio: sl(),
      secureStorage: sl(),
      client: sl(),
    ),
  );
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<AnnouncementCubit>(
    () => AnnouncementCubit(repository: sl()),
  );
  sl.registerFactory<ManageAnnouncementsCubit>(
    () => ManageAnnouncementsCubit(repository: sl()),
  );

  // -- Student Feature (القديم) --
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<StudentCubit>(() => StudentCubit(studentRepository: sl()));
  // sl.registerFactory<ManageStudentCubit>(() => ManageStudentCubit(studentRepository: sl())); // <-- تم تعطيل هذا السطر المسبب للتعارض

  // -- Teacher Feature --
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<TeacherCubit>(() => TeacherCubit(teacherRepository: sl()));
  sl.registerFactory<ManageTeacherCubit>(
    () => ManageTeacherCubit(teacherRepository: sl()),
  );

  // -- Course Feature --
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<CourseCubit>(() => CourseCubit(courseRepository: sl()));
  sl.registerFactory<ManageCourseCubit>(
    () => ManageCourseCubit(courseRepository: sl()),
  );

  // -- Classroom Feature --
  sl.registerLazySingleton<ClassroomRemoteDataSource>(
    () => ClassroomRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<ClassroomCubit>(
    () => ClassroomCubit(classroomRepository: sl()),
  );
  sl.registerFactory<ManageClassroomCubit>(
    () => ManageClassroomCubit(classroomRepository: sl()),
  );

  // -- Exams Feature --
  sl.registerLazySingleton<ExamsRemoteDataSource>(
    () => ExamsRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<ExamsRepository>(
    () => ExamsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<ExamCubit>(() => ExamCubit(examsRepository: sl()));
  sl.registerFactory<ManageExamCubit>(
    () => ManageExamCubit(examsRepository: sl()),
  );
  sl.registerFactory<StudentExamResultsCubit>(
    () => StudentExamResultsCubit(examsRepository: sl()),
  );

  // -- Exam Hall Assignment Feature --
  sl.registerLazySingleton<ExamHallAssignmentRemoteDataSource>(
    () =>
        ExamHallAssignmentRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<ExamHallAssignmentRepository>(
    () => ExamHallAssignmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<ExamHallAssignmentCubit>(
    () => ExamHallAssignmentCubit(repository: sl()),
  );

  // -- Users Feature --
  sl.registerLazySingleton<AppUserRemoteDataSource>(
    () => AppUserRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<AppUserRepository>(
    () => AppUserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<AppUserCubit>(() => AppUserCubit(repository: sl()));
}
