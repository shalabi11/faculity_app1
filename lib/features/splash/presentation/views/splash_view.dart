// lib/features/splash/presentation/views/splash_view.dart

import 'dart:async';

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد شاشة تسجيل الدخول والكيوبت الخاص بها
import '../../../auth/presentation/cubit/login_cubit.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    // الانتظار لمدة 3 ثوانٍ ثم الانتقال
    Timer(const Duration(seconds: 3), () {
      // استخدام pushReplacement لمنع المستخدم من الرجوع إلى شاشة البداية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                // اطلب الـ Cubit من الـ Service Locator
                // هو سيتكفل بإنشاء كل السلسلة (Repository, DataSource, Dio)
                create: (context) => sl<LoginCubit>(),
                child: const LoginScreen(),
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // يمكنك استخدام نفس لون الثيم
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.white)
                .animate()
                .fade(duration: 1500.ms)
                .scale(begin: const Offset(0.5, 0.5)),
            const SizedBox(height: 20),
            const Text(
              'CollegeHub',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate().fade(delay: 500.ms, duration: 1500.ms),
          ],
        ),
      ),
    );
  }
}
