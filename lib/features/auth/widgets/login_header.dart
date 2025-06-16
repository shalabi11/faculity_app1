//==============================================================================
// 1. ويدجت الهيدر (العنوان واللوقو)
//==============================================================================
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.school,
          size: 80,
          color: Colors.white,
        ).animate().fade(delay: 200.ms).scale(duration: 400.ms),
        const SizedBox(height: 16),
        const Text(
          'أهلاً بك 😊 ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fade(delay: 300.ms).slideY(begin: 0.5, duration: 500.ms),
        const SizedBox(height: 8),
        const Text(
          'سجل الدخول للمتابعة',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ).animate().fade(delay: 400.ms),
      ],
    );
  }
}
