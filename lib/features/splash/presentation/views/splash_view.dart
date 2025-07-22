import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_state.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/screens/login_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // --- هذا هو المنطق الصحيح والوحيد ---
    // الاستماع إلى حالة المصادقة لمرة واحدة فقط
    return BlocListener<AuthCubit, AuthState>(
      // `listenWhen` يمنع المستمع من العمل على الحالات الأولية غير المهمة
      listenWhen:
          (previous, current) =>
              current is Authenticated || current is Unauthenticated,
      listener: (context, state) {
        // لا حاجة لـ Future.delayed هنا، لأن شاشة البداية ستظل ظاهرة
        // حتى تأتي حالة جديدة من الـ AuthCubit
        if (state is Authenticated) {
          switch (state.user.role) {
            case 'admin':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminDashboardScreen(user: state.user),
                ),
              );
              break;
            case 'student':
            default: // الخيار الافتراضي هو شاشة الطالب
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentMainScreen(user: state.user),
                ),
              );
              break;
          }
        } else if (state is Unauthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider(
                    create: (context) => sl<LoginCubit>(),
                    child: const LoginScreen(),
                  ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
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
                '',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fade(delay: 500.ms, duration: 1500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
