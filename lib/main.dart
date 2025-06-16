// lib/main.dart
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// استيراد شاشة البداية الجديدة
import 'features/splash/presentation/views/splash_view.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // لاحظ أن MultiBlocProvider غير موجود هنا الآن
    return MaterialApp(
      title: 'College Hub',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(/* ... نفس الثيم الأزرق ... */),

      // الشاشة الرئيسية الآن هي شاشة البداية
      home: const SplashView(),
    );
  }
}
