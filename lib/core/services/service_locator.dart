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
import 'package:faculity_app2/features/exams/data/datasource/exams_remote_data_source.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository.dart';
import 'package:faculity_app2/features/exams/domain/repositories/exams_repository_impl.dart';
import 'package:faculity_app2/features/exams/presentation/cubit/exam_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/home_cubit.dart';
import 'package:faculity_app2/features/main_screen/presentation/cubit/main_screen_cubit.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository_impl.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // =====================
  //  Auth Feature
  // =====================
  sl.registerLazySingleton(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => LoginCubit(authRepository: sl()));
  sl.registerFactory(() => RegisterCubit(authRepository: sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );

  // =====================
  //  Main Screen & Home Features
  // =====================
  sl.registerFactory(() => MainScreenCubit());
  sl.registerFactory(() => HomeCubit(scheduleRepository: sl()));

  // =====================
  //  Schedule Feature
  // =====================
  sl.registerFactory(() => ScheduleCubit(repository: sl()));
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  Announcement Feature
  // =====================
  sl.registerFactory(() => AnnouncementCubit(repository: sl()));
  sl.registerFactory(() => ManageAnnouncementsCubit(repository: sl()));
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(dio: sl(), secureStorage: sl()),
  );

  // =====================
  //  Exams Feature
  // =====================
  sl.registerFactory(() => ExamsCubit(repository: sl()));
  sl.registerLazySingleton<ExamsRepository>(
    () => ExamsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ExamsRemoteDataSource>(
    () => ExamsRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  Notifications (Mocked)
  // =====================
  // sl.registerFactory(() => NotificationsCubit(repository: sl()));
  // sl.registerLazySingleton<NotificationRepository>(
  //   () => MockNotificationRepositoryImpl(),
  // );

  // =====================
  //  Theme
  // =====================
  sl.registerFactory(() => ThemeCubit(sharedPreferences: sl()));

  // =====================
  //  External
  // =====================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
