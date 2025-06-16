// lib/features/auth/presentation/widgets/role_selector_widget.dart
import 'package:flutter/material.dart';

class RoleSelectorWidget extends StatefulWidget {
  final Function(String) onRoleSelected;

  const RoleSelectorWidget({super.key, required this.onRoleSelected});

  @override
  State<RoleSelectorWidget> createState() => _RoleSelectorWidgetState();
}

class _RoleSelectorWidgetState extends State<RoleSelectorWidget> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _roles = [
    {'name': 'طالب', 'value': 'student', 'icon': Icons.person_outline},
    {'name': 'دكتور', 'value': 'teacher', 'icon': Icons.school_outlined},
    {'name': 'موظف', 'value': 'staff', 'icon': Icons.work_outline},
    {
      'name': 'مسؤول',
      'value': 'admin',
      'icon': Icons.admin_panel_settings_outlined,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_roles.length, (index) {
            bool isSelected = _selectedIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                    widget.onRoleSelected(_roles[index]['value']);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _roles[index]['icon'],
                        color: isSelected ? Colors.blue : Colors.grey.shade600,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _roles[index]['name'],
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected ? Colors.blue : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
