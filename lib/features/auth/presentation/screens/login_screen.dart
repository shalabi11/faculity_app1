// lib/features/auth/presentation/screens/login_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/presentation/screens/register_screen.dart';
import 'package:faculity_app2/features/auth/widgets/role_selector_widget.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exams_office_dashboard.dart';
import 'package:faculity_app2/features/head_of_department/presentation/screens/head_of_department_dashboard_screen.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/exams_for_publishing_screen.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/head_of_exams_dashboard_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';
import 'package:faculity_app2/features/personnel_office/presentation/screens/personnel_dashboard_screen.dart';
import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/teacher_list_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/screen_of_teacher/teacher_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../cubit/login_cubit.dart';
import '../../domain/entities/user.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _extraFieldController = TextEditingController();
  String _selectedRole = 'student';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _extraFieldController.dispose();
    super.dispose();
  }

  void _onRoleChanged(String newRole) {
    if (_selectedRole != newRole) {
      _extraFieldController.clear();
      setState(() {
        _selectedRole = newRole;
      });
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      // ✨ --- تم التعديل الكامل هنا --- ✨
      String apiRole;
      if (_selectedRole == 'student') {
        apiRole = 'student';
      } else if (_selectedRole == 'teacher') {
        apiRole = 'teacher'; // دور الدكتور يرسل كـ "teacher"
      } else {
        apiRole = 'admin'; // بقية الأدوار الإدارية ترسل كـ "admin"
      }

      final extraFieldConfig = _extraFieldConfig[_selectedRole];
      final Map<String, dynamic> data = {
        'role': apiRole,
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      if (extraFieldConfig != null) {
        data[extraFieldConfig['name']] = _extraFieldController.text.trim();
      }
      context.read<LoginCubit>().login(data: data);
    }
  }

  void _navigateByRole(BuildContext context, String selectedRole, User user) {
    Widget screen;
    switch (selectedRole) {
      case 'admin':
        screen = AdminDashboardScreen(user: user);
        break;
      case 'teacher':
        screen = TeacherMainScreen(user: user);
        break;
      case 'staff':
        screen = const StaffListScreen();
        break;
      case 'studentAffairs':
        screen = const StudentAffairsDashboardScreen();
        break;
      case 'personnel_office':
        screen = const PersonnelDashboardScreen();
        break;
      case 'exams':
        screen = const ExamsOfficeDashboardScreen();
        break;
      case 'head_of_exam':
        screen = HeadOfExamsDashboardScreen(user: user);
        break;
      case 'head_of_department':
        screen = HeadOfDepartmentDashboardScreen(user: user);
        break;
      case 'student':
      default:
        screen = StudentMainScreen(user: user);
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthCubit>().loggedIn(state.user);
          _navigateByRole(context, _selectedRole, state.user);
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final extraFieldConfig = _extraFieldConfig[_selectedRole];

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary.withOpacity(0.9), Colors.white],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const _WelcomeHeader(),
                        const SizedBox(height: 18),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  RoleSelectorWidget(
                                    onRoleSelected: _onRoleChanged,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _emailController,
                                    textAlign: TextAlign.right,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'البريد الإلكتروني',
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'الرجاء إدخال البريد الإلكتروني';
                                      }
                                      if (!v.contains('@')) {
                                        return 'بريد إلكتروني غير صالح';
                                      }
                                      return null;
                                    },
                                  ),
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child:
                                        extraFieldConfig == null
                                            ? const SizedBox.shrink()
                                            : Column(
                                              children: [
                                                const SizedBox(height: 12),
                                                TextFormField(
                                                  controller:
                                                      _extraFieldController,
                                                  textAlign: TextAlign.right,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        extraFieldConfig['label'],
                                                    prefixIcon: Icon(
                                                      extraFieldConfig['icon'],
                                                    ),
                                                  ),
                                                  validator: (v) {
                                                    if (v == null ||
                                                        v.isEmpty) {
                                                      return 'الرجاء إدخال ${extraFieldConfig['label']}';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordController,
                                    textAlign: TextAlign.right,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'كلمة المرور',
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'الرجاء إدخال كلمة المرور';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: isLoading ? null : _login,
                                    child:
                                        isLoading
                                            ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                      Colors.white,
                                                    ),
                                              ),
                                            )
                                            : const Text('تسجيل الدخول'),
                                  ),
                                  const SizedBox(height: 20),
                                  // _buildSignUpPrompt(context),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fade(duration: 500.ms).slideY(begin: 0.5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('ليس لديك حساب؟'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterScreen()),
            );
          },
          child: const Text('أنشئ حساباً'),
        ),
      ],
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/it_logo.png', height: 80)
                .animate()
                .fade(delay: 200.ms, duration: 500.ms)
                .slideY(begin: -0.5, curve: Curves.easeOut),
            const Text(
                  '        جامعة حلب \nكلية الهندسة المعلوماتية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
                .animate()
                .fade(delay: 200.ms, duration: 500.ms)
                .slideY(begin: -0.5, curve: Curves.easeOut),

            Image.asset('assets/images/aleppo_univercity_logo.png', height: 80)
                .animate()
                .fade(delay: 200.ms, duration: 500.ms)
                .slideY(begin: -0.5, curve: Curves.easeOut),
          ],
        ),

        // Material(
        //   color: Colors.transparent,
        //   child: Container(
        //     width: 110,
        //     height: 110,
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
        //     ),
        //   ),
        // ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        // const SizedBox(height: 16),
        const Text(
              'مرحباً بعودتك!',
              style: TextStyle(
                fontSize: 24,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
            .animate()
            .fade(delay: 200.ms, duration: 500.ms)
            .slideY(begin: -0.5, curve: Curves.easeOut),
        const SizedBox(height: 4),
        const Text(
          'سجل الدخول للمتابعة',
          style: TextStyle(color: Colors.black),
        ).animate().fade(delay: 400.ms, duration: 500.ms),
      ],
    );
  }
}

const Map<String, Map<String, dynamic>?> _extraFieldConfig = {
  'student': {
    'name': 'university_id',
    'label': 'الرقم الجامعي',
    'icon': Icons.school_outlined,
  },
  'teacher': {
    'name': 'employee_id',
    'label': 'الرقم الوظيفي',
    'icon': Icons.badge_outlined,
  },
  'staff': null,
  'admin': null,
  'dean': null,
  'studentAffairs': null,
  'personnel_office': null,
  'exams': null,
  'head_of_exam': null,
};
