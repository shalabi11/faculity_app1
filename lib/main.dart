// lib/main.dart
import 'package:faculity_app2/core/bloc/simple_bloc_observer.dart';
import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/theme/app_theme.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/screens/register_screen.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupServiceLocator();
  Bloc.observer = SimpleBlocObserver();
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
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Or ThemeMode.system
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: const SplashView(),
      ),
    );
  }
}
