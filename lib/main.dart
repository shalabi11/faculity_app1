import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/core/theme/app_theme.dart';
import 'package:faculity_app2/core/theme/cubit/theme_cubit.dart';
import 'package:faculity_app2/core/theme/cubit/theme_state.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/schedule/presentation/screens/add_schedule_screen.dart';
import 'package:faculity_app2/features/splash/presentation/views/splash_view.dart';
import 'package:faculity_app2/features/student/presentation/screens/mange_student_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // ضمان تهيئة كل خدمات فلاتر الأساسية قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  // إعداد كل التبعيات والخدمات بشكل غير متزامن
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MultiBlocProvider لتوفير الـ Cubits العامة لكل التطبيق
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()..appStarted()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'College Hub',
            debugShowCheckedModeBanner: false,

            // تطبيق الثيمات
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,

            // إعدادات اللغة العربية
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // نقطة انطلاق واجهة المستخدم
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
