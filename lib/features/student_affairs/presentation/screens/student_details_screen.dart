// lib/features/student_affairs/presentation/screens/student_details_screen.dart

import 'package:faculity_app2/core/services/service_locator.dart' as di;
import 'package:faculity_app2/features/student/data/models/student_model.dart';
import 'package:faculity_app2/features/student/domain/entities/student.dart';
import 'package:faculity_app2/features/student_affairs/presentation/cubit/manage_student_cubit.dart';
import 'package:faculity_app2/features/student_affairs/presentation/screens/add_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsScreen extends StatelessWidget {
  final Student student;

  const StudentDetailsScreen({super.key, required this.student});

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: Text(
              'هل أنت متأكد أنك تريد حذف الطالب "${student.fullName}"؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ManageStudentCubit>().deleteStudent(
                    id: student.id,
                  );
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('حذف', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ManageStudentCubit>(),
      child: BlocListener<ManageStudentCubit, ManageStudentState>(
        listener: (context, state) async {
          if (state is ManageStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            await Future.delayed(const Duration(milliseconds: 300));
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          } else if (state is ManageStudentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text(student.fullName),
                backgroundColor: Colors.teal.shade700,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal.shade100,
                        child: Text(
                          student.fullName.isNotEmpty
                              ? student.fullName[0]
                              : '',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.teal.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow('الاسم الكامل', student.fullName),
                    _buildDetailRow('الرقم الجامعي', student.universityId),
                    _buildDetailRow('اسم الأم', student.motherName),
                    _buildDetailRow(
                      'تاريخ الميلاد',
                      student.birthDate.toString().split(' ')[0],
                    ),
                    _buildDetailRow('مكان الولادة', student.birthPlace),
                    _buildDetailRow('القسم', student.department),
                    _buildDetailRow('السنة الدراسية', student.year),
                    const SizedBox(height: 24),

                    // ✨ --- تم التعديل هنا: إضافة بطاقة الأزرار --- ✨
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton.icon(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.blue.shade600,
                              ),
                              label: Text(
                                'تعديل',
                                style: TextStyle(color: Colors.blue.shade600),
                              ),
                              onPressed: () async {
                                final result = await Navigator.of(
                                  context,
                                ).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => AddStudentScreen(),
                                  ),
                                );
                                if (result == true && context.mounted) {
                                  Navigator.of(context).pop(true);
                                }
                              },
                            ),
                            TextButton.icon(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade600,
                              ),
                              label: Text(
                                'حذف',
                                style: TextStyle(color: Colors.red.shade600),
                              ),
                              onPressed:
                                  () => _showDeleteConfirmationDialog(context),
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
