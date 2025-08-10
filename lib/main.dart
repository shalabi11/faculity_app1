import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupServiceLocator();

  final secureStorage = di.sl<FlutterSecureStorage>();
  const String tempAuthToken =
      '19|aEn2hLha0u9tIQhKISIIsxjTHYOi95rXq0IJ1uKJ6835ff61'; // ضع التوكن هنا
  await secureStorage.write(key: 'auth_token', value: tempAuthToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AuthCubit>()..appStarted(),
      child: MaterialApp(
        title: 'College Hub',
        theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Cairo'),
        debugShowCheckedModeBanner: false,
        // localizationsDelegates: [
        //   GlobalMaterializations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: const [Locale('ar', 'AE')],
        // locale: const Locale('ar', 'AE'),
        home: const SplashView(),
      ),
    );
  }
}
