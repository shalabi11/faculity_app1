// lib/core/services/service_locator.dart
import 'package:dio/dio.dart';
import 'package:faculity_app2/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:get_it/get_it.dart';

// استيراد كل الطبقات التي أنشأناها
import '../../features/auth/data/datasources/auth_remote_data_source.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';

// إنشاء نسخة من GetIt
final sl = GetIt.instance;

// دالة لإعداد وتسجيل كل التبعيات
void setupServiceLocator() {
  // =====================
  //  CUBITS
  // =====================
  // عند طلب Cubit، قم بإنشاء نسخة جديدة منه (factory)
  sl.registerFactory(() => LoginCubit(authRepository: sl()));
  sl.registerFactory(() => RegisterCubit(authRepository: sl()));

  // =====================
  //  REPOSITORIES
  // =====================
  // الـ Repository سيعتمد على الـ DataSource
  // نستخدم lazySingleton لأنه لا داعي لإنشائه إلا عند أول استخدام
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // =====================
  //  DATA SOURCES
  // =====================
  // الـ DataSource سيعتمد على Dio
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // =====================
  //  EXTERNAL (مثل Dio)
  // =====================
  // تسجيل كائن Dio كـ Singleton لكي يستخدمه التطبيق بأكمله
  sl.registerLazySingleton(() => Dio());
}
