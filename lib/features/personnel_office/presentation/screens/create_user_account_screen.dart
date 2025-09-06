// lib/features/personnel_office/presentation/screens/create_user_account_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:faculity_app2/features/staff/presentation/screens/add_edit_staff_screen.dart';
import 'package:faculity_app2/features/teachers/presentation/screens/add_edit_teacher_screen/add_edit_teacher_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Map<String, String> _departmentsMap = {
  'هندسة البرمجيات': 'SE',
  'الذكاء الصنعي': 'AI',
  'الشبكات': 'NE',
};

const Map<String, List<Map<String, dynamic>>> _fieldsConfig = {
  'teacher': [
    {'name': 'name', 'label': 'الاسم الكامل', 'icon': Icons.person_outline},
    {
      'name': 'employee_id',
      'label': 'الرقم الوظيفي',
      'icon': Icons.badge_outlined,
    },
    {
      'name': 'email',
      'label': 'البريد الإلكتروني (شكلي)',
      'icon': Icons.email_outlined,
      'keyboardType': TextInputType.emailAddress,
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
};

class CreateUserAccountScreen extends StatelessWidget {
  const CreateUserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterCubit>(),
      child: const _CreateUserAccountView(),
    );
  }
}

class _CreateUserAccountView extends StatefulWidget {
  const _CreateUserAccountView();

  @override
  State<_CreateUserAccountView> createState() => _CreateUserAccountViewState();
}

class _CreateUserAccountViewState extends State<_CreateUserAccountView> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  String _selectedRole = 'teacher';
  String? _selectedDepartmentValue;
  Map<String, dynamic> _dataForNextScreen = {};

  @override
  void initState() {
    super.initState();
    _updateControllersForRole(_selectedRole);
  }

  void _updateControllersForRole(String role) {
    _formKey.currentState?.reset();
    _controllers.values.forEach((controller) => controller.dispose());
    _controllers.clear();
    final fields = _fieldsConfig[role] ?? [];
    for (var field in fields) {
      _controllers[field['name']] = TextEditingController();
    }
    setState(() {
      _selectedDepartmentValue = null;
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> formData = {'role': _selectedRole};
      _controllers.forEach((key, controller) {
        formData[key] = controller.text.trim();
      });
      formData['department'] = _selectedDepartmentValue;

      _dataForNextScreen = Map<String, dynamic>.from(formData);
      final Map<String, dynamic> apiData = Map<String, dynamic>.from(formData);

      if (_selectedRole == 'teacher') {
        apiData.remove('email');
      }

      context.read<RegisterCubit>().register(data: apiData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFields = _fieldsConfig[_selectedRole] ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب جديد')),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إنشاء الحساب بنجاح! يتم الآن توجيهك لإضافة البيانات...',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // ✨ التصحيح: إضافة user.id إلى البيانات قبل الانتقال
            _dataForNextScreen['user_id'] = state.user.id;

            if (_selectedRole == 'teacher') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (_) =>
                          AddEditTeacherScreen(initialData: _dataForNextScreen),
                ),
              );
            } else if (_selectedRole == 'staff') {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder:
                      (_) =>
                          AddEditStaffScreen(initialData: _dataForNextScreen),
                ),
              );
            }
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'اختر الدور',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'teacher', child: Text('دكتور')),
                      DropdownMenuItem(value: 'staff', child: Text('موظف')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedRole = value;
                          _updateControllersForRole(value);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ...currentFields.map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _controllers[field['name']],
                        obscureText: field['isPassword'] ?? false,
                        keyboardType: field['keyboardType'],
                        decoration: InputDecoration(
                          labelText: field['label'],
                          prefixIcon: Icon(field['icon']),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            if (field['name'] == 'email' &&
                                _selectedRole == 'teacher') {
                              return null;
                            }
                            return 'هذا الحقل مطلوب';
                          }
                          if (field['name'] == 'password_confirmation') {
                            if (value != _controllers['password']?.text) {
                              return 'كلمتا المرور غير متطابقتين';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectedDepartmentValue,
                      decoration: const InputDecoration(
                        labelText: 'القسم',
                        prefixIcon: Icon(Icons.business_center_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items:
                          _departmentsMap.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.value,
                              child: Text(entry.key),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartmentValue = value;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? 'الرجاء اختيار القسم' : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'إنشاء حساب ومتابعة',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
