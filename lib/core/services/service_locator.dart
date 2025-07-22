// lib/core/services/service_locator.dart

import 'package:dio/dio.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // =====================
  //  External
  // =====================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // =====================
  //  Theme
  // =====================
  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(sharedPreferences: sl<SharedPreferences>()),
  );

  // =====================
  //  Auth Feature
  // =====================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(authRepository: sl<AuthRepository>()),
  );

  // =====================
  //  Main Screen & Home Features
  // =====================
  sl.registerFactory<MainScreenCubit>(() => MainScreenCubit());
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(scheduleRepository: sl<ScheduleRepository>()),
  );

  // =====================
  //  Schedule Feature
  // =====================
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      remoteDataSource: sl<ScheduleRemoteDataSource>(),
    ),
  );
  sl.registerFactory<ScheduleCubit>(
    () => ScheduleCubit(repository: sl<ScheduleRepository>()),
  );
  sl.registerFactory<ManageScheduleCubit>(
    () => ManageScheduleCubit(repository: sl<ScheduleRepository>()),
  );

  // =======================================================
  //  Announcement Feature (القسم الذي تم تنظيفه بالكامل)
  // =======================================================
  // 3. تسجيل مصدر البيانات (يتم تسجيله مرة واحدة فقط)
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(
      client: sl<Dio>(), // تأكد من أن الـ client هو Dio
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  // 2. تسجيل الـ Repository (يتم تسجيله مرة واحدة فقط)
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      remoteDataSource: sl<AnnouncementRemoteDataSource>(),
    ),
  );
  // 1. تسجيل الـ Cubits (كلاهما يعتمد على نفس الـ Repository)
  sl.registerFactory<AnnouncementCubit>(
    () => AnnouncementCubit(
      announcementRepository: sl<AnnouncementRepository>(),
      repository: sl(),
    ),
  );
  sl.registerFactory<ManageAnnouncementsCubit>(
    () => ManageAnnouncementsCubit(
      announcementRepository: sl<AnnouncementRepository>(),
      repository: sl(),
    ),
  );

  // =====================
  //  Student Feature
  // =====================
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<StudentRepository>(
    () =>
        StudentRepositoryImpl(remoteDataSource: sl<StudentRemoteDataSource>()),
  );
  sl.registerFactory<StudentCubit>(
    () => StudentCubit(studentRepository: sl<StudentRepository>()),
  );
  sl.registerFactory<ManageStudentCubit>(
    () => ManageStudentCubit(studentRepository: sl<StudentRepository>()),
  );

  // =====================
  //  Teacher Feature
  // =====================
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<TeacherRepository>(
    () =>
        TeacherRepositoryImpl(remoteDataSource: sl<TeacherRemoteDataSource>()),
  );
  sl.registerFactory<TeacherCubit>(
    () => TeacherCubit(teacherRepository: sl<TeacherRepository>()),
  );
  sl.registerFactory<ManageTeacherCubit>(
    () => ManageTeacherCubit(teacherRepository: sl<TeacherRepository>()),
  );

  // =====================
  //  Course Feature
  // =====================
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl<CourseRemoteDataSource>()),
  );
  sl.registerFactory<CourseCubit>(
    () => CourseCubit(courseRepository: sl<CourseRepository>()),
  );
  sl.registerFactory<ManageCourseCubit>(
    () => ManageCourseCubit(courseRepository: sl<CourseRepository>()),
  );

  // =====================
  //  Classroom Feature
  // =====================
  sl.registerLazySingleton<ClassroomRemoteDataSource>(
    () => ClassroomRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<ClassroomRepository>(
    () => ClassroomRepositoryImpl(
      remoteDataSource: sl<ClassroomRemoteDataSource>(),
    ),
  );
  sl.registerFactory<ClassroomCubit>(
    () => ClassroomCubit(classroomRepository: sl<ClassroomRepository>()),
  );
  sl.registerFactory<ManageClassroomCubit>(
    () => ManageClassroomCubit(classroomRepository: sl<ClassroomRepository>()),
  );

  // =====================
  //  Exams Feature
  // =====================
  sl.registerLazySingleton<ExamsRemoteDataSource>(
    () => ExamsRemoteDataSourceImpl(
      dio: sl<Dio>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  sl.registerLazySingleton<ExamsRepository>(
    () => ExamsRepositoryImpl(remoteDataSource: sl<ExamsRemoteDataSource>()),
  );
  sl.registerFactory<ExamCubit>(
    () => ExamCubit(examsRepository: sl<ExamsRepository>()),
  );
  sl.registerFactory<ManageExamCubit>(
    () => ManageExamCubit(examsRepository: sl<ExamsRepository>()),
  );
  sl.registerFactory<StudentExamResultsCubit>(
    () => StudentExamResultsCubit(examsRepository: sl<ExamsRepository>()),
  );

  // =====================
  //  Exam Hall Assignment Feature
  // =====================
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

  // =====================
  //  Users Feature
  // =====================
  sl.registerLazySingleton<AppUserRemoteDataSource>(
    () => AppUserRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<AppUserRepository>(
    () => AppUserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory<AppUserCubit>(() => AppUserCubit(repository: sl()));
}
