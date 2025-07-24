import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:faculity_app2/core/services/service_locator.dart'
    as di; // <-- تم التعديل هنا
import 'package:faculity_app2/features/student_affairs/presentation/cubit/student_affairs_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  // التأكد من تهيئة كل شيء قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  // استدعاء دالة تهيئة الاعتماديات من الملف الصحيح
  await di.setupServiceLocator(); // <-- تم التعديل هنا
  // --- 3. أضف هذا الكود بالكامل ---
  // ==================== كود مؤقت للتجربة فقط ====================
  final secureStorage = di.sl<FlutterSecureStorage>();

  // !!! مهم جداً: الصق التوكن الحقيقي الذي نسخته من Postman هنا
  const String tempAuthToken =
      '12|JSqDUnL64ldWQZhrvQPowmcmswyyj1T4v5Zm204Y57f4c06d';

  await secureStorage.write(key: 'auth_token', value: tempAuthToken);
  // ===============================================================

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام BlocProvider لتوفير الـ Cubit للشاشة
    return BlocProvider(
      create:
          (_) => di.sl<StudentAffairsCubit>(), // <-- إنشاء Cubit شؤون الطلاب
      child: MaterialApp(
        title: 'College Hub - Test Mode',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Cairo', // يمكنك تحديد خط عربي مناسب هنا
        ),
        debugShowCheckedModeBanner: false,
        // إعدادات دعم اللغة العربية
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'AE')],
        locale: const Locale('ar', 'AE'),
        // جعل شاشة شؤون الطلاب هي الشاشة الرئيسية للتجربة
        home: const StudentAffairsDashboardScreen(),
      ),
    );
  }
}
