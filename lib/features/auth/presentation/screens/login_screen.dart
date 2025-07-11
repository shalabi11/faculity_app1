import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/widgets/login_header.dart';
import 'package:faculity_app2/features/auth/widgets/role_selector_widget.dart';
import 'package:faculity_app2/features/auth/widgets/sign_up_prompt.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // توفير الـ Cubit في الأعلى
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      // بناء الواجهة الفعلية باستخدام context جديد
      child: const _LoginView(),
    );
  }
}

// ===============================================
//  ويدجت عرض الواجهة
// ===============================================
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
      final extraFieldConfig = _extraFieldConfig[_selectedRole];
      final Map<String, dynamic> data = {
        'role': _selectedRole,
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      };

      if (extraFieldConfig != null) {
        data[extraFieldConfig['name']] = _extraFieldController.text.trim();
      }

      context.read<LoginCubit>().login(data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.read<AuthCubit>().loggedIn(state.user);
          switch (state.user.role) {
            case 'admin':
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (_) => AdminDashboardScreen(
                        user: state.user,
                      ), // <-- المشكلة هنا
                ),
              );

              break;
            case 'student':
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (_) => StudentMainScreen(
                        user: state.user,
                      ), // <-- المشكلة هنا
                ),
              );
              break;
            default:
          }
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final extraFieldConfig = _extraFieldConfig[_selectedRole];

        return Scaffold(
          body: AbsorbPointer(
            absorbing: isLoading,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade200, Colors.blue.shade500],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoginHeader(),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(24.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
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
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: 'البريد الإلكتروني',
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        !value.contains('@')) {
                                      return 'الرجاء إدخال بريد إلكتروني صالح';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return SizeTransition(
                                      sizeFactor: animation,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child:
                                      extraFieldConfig == null
                                          ? const SizedBox.shrink()
                                          : Padding(
                                            key: ValueKey(_selectedRole),
                                            padding: const EdgeInsets.only(
                                              bottom: 16.0,
                                            ),
                                            child: TextFormField(
                                              controller: _extraFieldController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    extraFieldConfig['label'],
                                                prefixIcon: Icon(
                                                  extraFieldConfig['icon'],
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'الرجاء إدخال ${extraFieldConfig['label']}';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: 'كلمة المرور',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  child:
                                      isLoading
                                          ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          )
                                          : const Text('تسجيل الدخول'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SignUpPrompt(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// هذه البيانات يجب أن تكون خارج أي كلاس
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
};
