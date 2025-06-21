//==============================================================================
// 3. ويدجت رابط إنشاء حساب جديد
//==============================================================================
import 'dart:ui';

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: unused_element
class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('ليس لديك حساب؟', style: TextStyle(color: Colors.white70)),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider(
                      create:
                          (context) => sl<RegisterCubit>(), // لا تنس استخدام sl
                      child: const RegisterScreen(),
                    ),
              ),
            );
          },
          child: const Text(
            'أنشئ حساباً',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ).animate().fade(delay: 700.ms);
  }
}
