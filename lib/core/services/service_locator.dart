import 'package:dio/dio.dart';
import 'package:faculity_app2/features/announcements/data/datasources/announcement_remote_data_source.dart';
import 'package:faculity_app2/features/announcements/domain/repositories/announcement_repository.dart';
import 'package:faculity_app2/features/announcements/domain/repositories/announcement_repository_impl.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/announcement_cubit.dart';
import 'package:faculity_app2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:faculity_app2/features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:faculity_app2/features/schedule/domain/repositories/schedule_repository_impl.dart';
import 'package:faculity_app2/features/schedule/presentation/cubit/schedule_cubit.dart';

import 'package:get_it/get_it.dart';

// إنشاء نسخة من GetIt
final sl = GetIt.instance;

// دالة لإعداد وتسجيل كل التبعيات
void setupServiceLocator() {
  // =====================
  //  AUTH FEATURE
  // =====================
  // Cubits
  sl.registerFactory(() => LoginCubit(authRepository: sl()));
  sl.registerFactory(() => RegisterCubit(authRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  SCHEDULE FEATURE
  // =====================
  // Cubit
  sl.registerFactory(() => ScheduleCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  ANNOUNCEMENT FEATURE
  // =====================
  // Cubit
  sl.registerFactory(() => AnnouncementCubit(repository: sl()));

  // Repository
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  EXTERNAL
  // =====================
  // تسجيل كائن Dio كـ Singleton لكي يستخدمه التطبيق بأكمله
  sl.registerLazySingleton(() => Dio());
}
