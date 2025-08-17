import 'package:flutter/material.dart';

class RoleSelectorWidget extends StatefulWidget {
  final Function(String) onRoleSelected;

  const RoleSelectorWidget({super.key, required this.onRoleSelected});

  @override
  State<RoleSelectorWidget> createState() => _RoleSelectorWidgetState();
}

class _RoleSelectorWidgetState extends State<RoleSelectorWidget> {
  String _selectedRole = 'student';
  final List<Map<String, dynamic>> _roles = [
    {'name': 'طالب', 'value': 'student', 'icon': Icons.person_outline},
    {'name': 'دكتور', 'value': 'teacher', 'icon': Icons.school_outlined},
    // {'name': 'موظف', 'value': 'staff', 'icon': Icons.work_outline},
    {
      'name': 'العميد',
      'value': 'admin',
      'icon': Icons.admin_panel_settings_outlined,
    },
    // {'name': 'عميد', 'value': 'dean', 'icon': Icons.star_outline},
    {
      'name': 'شؤون طلاب',
      'value': 'studentAffairs',
      'icon': Icons.groups_outlined,
    },
    {
      'name': 'ذاتية',
      'value': 'personnel_office',
      'icon': Icons.badge_outlined,
    },
    {'name': 'امتحانات', 'value': 'exams', 'icon': Icons.edit_note_outlined},
    {
      'name': 'رئيس امتحانات',
      'value': 'head_of_exam',
      'icon': Icons.grading_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تسجيل الدخول كـ:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        // تم تغليف الـ ListView بـ SizedBox لإعطائه ارتفاعاً محدداً
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _roles.length,
            itemBuilder: (context, index) {
              final role = _roles[index];
              final isSelected = _selectedRole == role['value'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = role['value'];
                  });
                  widget.onRoleSelected(role['value']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 75, // تحديد عرض ثابت لكل عنصر
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        role['icon'],
                        color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade600,
                        size: 28,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        role['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
