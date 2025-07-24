// import 'package:dio/dio.dart';
// import 'package:faculity_app2/core/platform/network_info.dart';
// // import 'package:faculity_app2/core/services/service_locator.dart';
// import 'package:faculity_app2/features/student_affairs/data/datasource/student_affairs_remote_data_source.dart';
// import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository.dart';
// import 'package:faculity_app2/features/student_affairs/data/repositories/student_affairs_repository_impl.dart';
// import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/add_student.dart';
// import 'package:faculity_app2/features/student_affairs/domain/entities/usecases/get_student_dashboard_data.dart';
// import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

// import 'features/student_affairs/presentation/cubit/manage_student_cubit.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   await sl.reset(dispose: false);

//   print("Registering dependencies...");

//   // ############ Features - Student Affairs ############

//   // Cubits
//   sl.registerFactory(() => StudentAffairsCubit(getStudentDashboardData: sl()));
//   sl.registerFactory(() => ManageStudentCubit(addStudentUseCase: sl()));

//   // Use cases
//   sl.registerLazySingleton(() => GetStudentDashboardData(sl()));
//   sl.registerLazySingleton(() => AddStudent(sl()));

//   // Repository
//   sl.registerLazySingleton<StudentAffairsRepository>(
//     () =>
//         StudentAffairsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
//   );

//   // Data sources
//   sl.registerLazySingleton<StudentAffairsRemoteDataSource>(
//     () => StudentAffairsRemoteDataSourceImpl(
//       dio: sl(),
//     ), // Using the test version for now
//   );

//   // ############ Core ############
//   sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

//   // ############ External ############
//   sl.registerLazySingleton(() => Dio());
//   sl.registerLazySingleton(() => const FlutterSecureStorage());
//   sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
// }
