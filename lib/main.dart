import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_theme.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => sl<AuthCubit>()..appStarted())],
      child: MaterialApp(
        title: 'College Hub',
        debugShowCheckedModeBanner: false,

        // --- استخدام الثيم الجديد من الملف المنفصل ---
        theme: AppTheme.lightTheme,

        // --- إعدادات اللغة ---
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        home: const SplashView(),
      ),
    );
  }
}
