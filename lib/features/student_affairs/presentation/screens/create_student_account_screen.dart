// lib/features/student_affairs/presentation/screens/create_student_account_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/core/widget/app_state_widget.dart';
import 'package:faculity_app2/features/auth/presentation/cubit/register_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const Map<String, String> _yearsMap = {
  'الأولى': '1',
  'الثانية': '2',
  'الثالثة': '3',
  'الرابعة': '4',
  'الخامسة': '5',
};
const Map<String, String> _departmentsMap = {
  'هندسة البرمجيات': 'SE',
  'الذكاء الصنعي': 'AI',
  'الشبكات': 'NE',
};

class CreateStudentAccountScreen extends StatelessWidget {
  const CreateStudentAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<RegisterCubit>(),
      child: const _CreateStudentAccountView(),
    );
  }
}

class _CreateStudentAccountView extends StatefulWidget {
  const _CreateStudentAccountView();

  @override
  State<_CreateStudentAccountView> createState() =>
      _CreateStudentAccountViewState();
}

class _CreateStudentAccountViewState extends State<_CreateStudentAccountView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _facultyController = TextEditingController(text: 'الهندسة المعلوماتية');
  final _sectionController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedYearValue;
  String? _selectedDepartmentValue;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateEmail);
    _universityIdController.addListener(_updateEmail);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateEmail);
    _universityIdController.removeListener(_updateEmail);
    _nameController.dispose();
    _universityIdController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _facultyController.dispose();
    _sectionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateEmail() {
    final name = _nameController.text.trim().split(' ').first.toLowerCase();
    final id = _universityIdController.text.trim();
    if (name.isNotEmpty && id.isNotEmpty) {
      setState(() {
        _emailController.text = '$name.$id@example.com';
      });
    } else {
      setState(() {
        _emailController.clear();
      });
    }
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'role': 'student',
        'name': _nameController.text.trim(),
        'university_id': _universityIdController.text.trim(),
        'password': _passwordController.text.trim(),
        'password_confirmation': _passwordConfirmationController.text.trim(),
        'faculty': _facultyController.text.trim(),
        'section': _sectionController.text.trim(),
        'year': _selectedYearValue,
        'department': _selectedDepartmentValue,
      };
      print('Sending data to register: $data');
      context.read<RegisterCubit>().register(data: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب طالب جديد')),
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تم إنشاء الحساب بنجاح! يتم الآن توجيهك لإضافة بياناته...',
                ),
                backgroundColor: Colors.green,
              ),
            );

            // ✨ --- التصحيح الرئيسي والنهائي هنا --- ✨
            // نستخدم البيانات مباشرة من الحقول التي ملأها المستخدم
            final initialData = {
              'name': _nameController.text.trim(),
              'university_id': _universityIdController.text.trim(),
              'department': _selectedDepartmentValue,
            };

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AddStudentScreen(initialData: initialData),
              ),
            );
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
                  _buildTextField(
                    controller: _nameController,
                    label: 'الاسم الكامل',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _universityIdController,
                    label: 'الرقم الجامعي',
                    icon: Icons.school_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني (يتم إنشاؤه تلقائياً)',
                    icon: Icons.email_outlined,
                    readOnly: true,
                    isRequired: false,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _passwordConfirmationController,
                    label: 'تأكيد كلمة المرور',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _facultyController,
                    label: 'الكلية',
                    icon: Icons.account_balance_outlined,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedYearValue,
                    decoration: const InputDecoration(
                      labelText: 'السنة الدراسية',
                      prefixIcon: Icon(Icons.class_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _yearsMap.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.value,
                            child: Text(entry.key),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYearValue = value;
                      });
                    },
                    validator:
                        (value) => value == null ? 'الرجاء اختيار السنة' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
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
                        (value) => value == null ? 'الرجاء اختيار القسم' : null,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _sectionController,
                    label: 'الفئة (A/B)',
                    icon: Icons.group_outlined,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: LoadingList(),
                            )
                            : const Text(
                              'إنشاء الحساب والمتابعة',
                              style: TextStyle(fontSize: 16),
                            ),
                  ),
                ],
              ).animate(delay: 50.ms).fade(duration: 200.ms).slideY(begin: 0.2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        fillColor: readOnly ? Colors.grey.shade200 : null,
        filled: readOnly,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return 'الرجاء إدخال $label';
        }
        if (validator != null) {
          return validator(value);
        }
        return null;
      },
    );
  }
}
