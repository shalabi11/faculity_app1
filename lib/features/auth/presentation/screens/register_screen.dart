import 'package:faculity_app2/features/auth/widgets/role_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/register_cubit.dart';

// ======================================================================
//  1. تعريف الحقول الكاملة لكل دور
// ======================================================================
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  @override
  Widget build(BuildContext context) {
    final currentFields = _registerFieldsConfig[_selectedRole] ?? [];
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
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
        return Scaffold(
          body: AbsorbPointer(
            absorbing: isLoading,
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.cyan.shade200, Colors.blue.shade500],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _RegisterHeader(),
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
                                ...currentFields
                                    .map((field) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
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
                                            hintText: field['label'],
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
                                      );
                                    })
                                    .toList()
                                    .animate(interval: 50.ms)
                                    .fade(duration: 200.ms)
                                    .slideX(begin: 0.1),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: isLoading ? null : _register,
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
                                          : const Text('إنشاء الحساب'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const _LoginPrompt(),
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

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.person_add_alt_1_outlined,
          size: 80,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        const Text(
          'إنشاء حساب جديد',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ).animate().fade(duration: 400.ms);
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'لديك حساب بالفعل؟',
          style: TextStyle(color: Colors.white70),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'سجل الدخول',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
