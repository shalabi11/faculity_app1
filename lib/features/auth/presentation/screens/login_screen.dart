import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/widgets/role_selector_widget.dart';
import 'package:faculity_app2/features/exams/presentation/screens/manage_exams_screen.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/exams_for_publishing_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';
import 'package:faculity_app2/features/personnel_office/presentation/screens/personnel_dashboard_screen.dart';
import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/teacher_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _LoginViewState extends State<_LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _extraFieldController = TextEditingController();
  String _selectedRole = 'student';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _extraFieldController.dispose();
    _animController.dispose();
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
      String apiRole = _selectedRole;
      if (_selectedRole != 'student') {
        apiRole = 'admin';
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
                // خلفية متدرجة
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
                        const SizedBox(height: 6),
                        // لوجو مع ظل
                        Hero(
                          tag: 'app-logo-hero',
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              width: 110,
                              height: 110,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              // يمكنك وضع صورة اللوجو هنا
                              // child: Image.asset('path/to/your/logo.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: const Text(
                            'مرحبا — سجّل دخولك',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // الفورم داخل Card
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
                                  // استخدام AnimatedSize لتوفير حركة عند ظهور الحقل الإضافي
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
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                      ),
                                      child:
                                          isLoading
                                              ? const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                        Colors.white,
                                                      ),
                                                ),
                                              )
                                              : const Text(
                                                'تسجيل الدخول',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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

  void _navigateByRole(BuildContext context, String selectedRole, User user) {
    switch (selectedRole) {
      case 'admin':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => AdminDashboardScreen(user: user)),
        );
        break;
      case 'student':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => StudentMainScreen(user: user)),
        );
        break;
      case 'teacher':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TeacherListScreen()),
        );
        break;
      case 'staff':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const StaffListScreen()),
        );
        break;
      case 'studentAffairs':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const StudentAffairsDashboardScreen(),
          ),
        );
        break;
      case 'personnel_office':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PersonnelDashboardScreen()),
        );
        break;
      case 'exams':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ManageExamsScreen()),
        );
        break;
      case 'head_of_exam':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ExamsForPublishingScreen()),
        );
        break;
      default:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => StudentMainScreen(user: user)),
        );
    }
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
