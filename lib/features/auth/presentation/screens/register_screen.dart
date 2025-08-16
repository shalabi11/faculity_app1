// lib/features/auth/presentation/screens/register_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:faculity_app2/features/auth/widgets/role_selector_widget.dart';
import 'package:faculity_app2/features/exams/presentation/screens/exams_office_dashboard.dart';
import 'package:faculity_app2/features/head_of_exams/presentation/screens/exams_for_publishing_screen.dart';
import 'package:faculity_app2/features/main_screen/presentation/screens/student_main_screen.dart';
import 'package:faculity_app2/features/personnel_office/presentation/screens/personnel_dashboard_screen.dart';
import 'package:faculity_app2/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/student_affairs_dashboard_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/teacher_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';
import '../cubit/register_cubit.dart';

const Map<String, List<Map<String, dynamic>>> _registerFieldsConfig = {
  'student': [
    {'name': 'name', 'label': 'الاسم الكامل', 'icon': Icons.person_outline},
    {
      'name': 'university_id',
      'label': 'الرقم الجامعي',
      'icon': Icons.school_outlined,
    },
    {
      'name': 'faculty',
      'label': 'الكلية',
      'icon': Icons.account_balance_outlined,
    },
    {
      'name': 'department',
      'label': 'القسم',
      'icon': Icons.business_center_outlined,
    },
    {'name': 'year', 'label': 'السنة الدراسية', 'icon': Icons.class_outlined},
    {'name': 'section', 'label': 'الفئة (A/B)', 'icon': Icons.group_outlined},
    {
      'name': 'password',
      'label': 'كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
    {
      'name': 'password_confirmation',
      'label': 'تأكيد كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
  ],
  'teacher': [
    {'name': 'name', 'label': 'الاسم الكامل', 'icon': Icons.person_outline},
    {
      'name': 'employee_id',
      'label': 'الرقم الوظيفي',
      'icon': Icons.badge_outlined,
    },
    {
      'name': 'department',
      'label': 'القسم',
      'icon': Icons.business_center_outlined,
    },
    {
      'name': 'position',
      'label': 'المنصب (مثال: دكتور)',
      'icon': Icons.work_outline,
    },
    {
      'name': 'password',
      'label': 'كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
    {
      'name': 'password_confirmation',
      'label': 'تأكيد كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
  ],
  'staff': [
    {'name': 'name', 'label': 'الاسم الكامل', 'icon': Icons.person_outline},
    {
      'name': 'email',
      'label': 'البريد الإلكتروني',
      'icon': Icons.email_outlined,
      'keyboardType': TextInputType.emailAddress,
    },
    {
      'name': 'department',
      'label': 'القسم',
      'icon': Icons.business_center_outlined,
    },
    {'name': 'position', 'label': 'المنصب الوظيفي', 'icon': Icons.work_outline},
    {
      'name': 'password',
      'label': 'كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
    {
      'name': 'password_confirmation',
      'label': 'تأكيد كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
  ],
  'admin': [
    {'name': 'name', 'label': 'الاسم الكامل', 'icon': Icons.person_outline},
    {
      'name': 'email',
      'label': 'البريد الإلكتروني',
      'icon': Icons.email_outlined,
      'keyboardType': TextInputType.emailAddress,
    },
    {
      'name': 'position',
      'label': 'المنصب (مثال: عميد الكلية)',
      'icon': Icons.star_outline,
    },
    {
      'name': 'password',
      'label': 'كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
    {
      'name': 'password_confirmation',
      'label': 'تأكيد كلمة المرور',
      'icon': Icons.lock_outline,
      'isPassword': true,
    },
  ],
};

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  String _selectedRole = 'student';

  @override
  void initState() {
    super.initState();
    _updateControllersForRole(_selectedRole);
  }

  void _updateControllersForRole(String role) {
    _formKey.currentState?.reset();
    _controllers.forEach((key, controller) => controller.dispose());
    _controllers.clear();
    final fields = _registerFieldsConfig[role] ?? [];
    for (var field in fields) {
      _controllers[field['name']] = TextEditingController();
    }
  }

  void _onRoleChanged(String newRole) {
    if (_selectedRole != newRole) {
      setState(() {
        _selectedRole = newRole;
        _updateControllersForRole(newRole);
      });
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {'role': _selectedRole};
      _controllers.forEach((key, controller) {
        data[key] = controller.text.trim();
      });
      context.read<RegisterCubit>().register(data: data);
    }
  }

  void _navigateByRole(BuildContext context, String targetRole, User user) {
    Widget screen;
    switch (targetRole) {
      case 'admin':
        screen = AdminDashboardScreen(user: user);
        break;
      case 'teacher':
        screen = const TeacherListScreen();
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
        screen = const ExamsForPublishingScreen();
        break;
      case 'student':
      default:
        screen = StudentMainScreen(user: user);
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFields = _registerFieldsConfig[_selectedRole] ?? [];
    final primary = Theme.of(context).primaryColor;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء الحساب وتسجيل الدخول بنجاح!'),
              backgroundColor: Colors.green,
            ),
          );
          _navigateByRole(context, state.target, state.user);
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل إنشاء الحساب: ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: AbsorbPointer(
              absorbing: isLoading,
              child: Stack(
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
                        children: [
                          const _RegisterHeader(),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    RoleSelectorWidget(
                                      onRoleSelected: _onRoleChanged,
                                    ),
                                    const SizedBox(height: 20),
                                    ...currentFields
                                        .map(
                                          (field) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  _controllers[field['name']],
                                              obscureText:
                                                  field['isPassword'] ?? false,
                                              keyboardType:
                                                  field['keyboardType'] ??
                                                  TextInputType.text,
                                              decoration: InputDecoration(
                                                labelText: field['label'],
                                                prefixIcon: Icon(field['icon']),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'الرجاء إدخال ${field['label']}';
                                                }
                                                if (field['name'] ==
                                                    'password_confirmation') {
                                                  if (value !=
                                                      _controllers['password']
                                                          ?.text) {
                                                    return 'كلمتا المرور غير متطابقتين';
                                                  }
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        )
                                        .toList()
                                        .animate(interval: 50.ms)
                                        .fade(duration: 200.ms)
                                        .slideX(begin: -0.1),
                                    const SizedBox(height: 14),
                                    ElevatedButton(
                                      onPressed: isLoading ? null : _register,
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
                                              : const Text('إنشاء الحساب'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ).animate().fade(duration: 500.ms).slideY(begin: 0.5),
                          const SizedBox(height: 16),
                          const _LoginPrompt(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
              ),
              child: Icon(
                Icons.person_add_alt_1,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: 16),
        const Text(
              'إنشاء حساب جديد',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
            .animate()
            .fade(delay: 200.ms, duration: 500.ms)
            .slideY(begin: -0.5, curve: Curves.easeOut),
        const SizedBox(height: 4),
        const Text(
          'املأ الحقول التالية للمتابعة',
          style: TextStyle(color: Colors.black54),
        ).animate().fade(delay: 400.ms, duration: 500.ms),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'سجل الدخول',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ).animate().fade(delay: 700.ms);
  }
}
