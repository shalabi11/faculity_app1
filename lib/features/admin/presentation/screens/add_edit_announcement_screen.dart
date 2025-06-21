import 'dart:io';
import 'package:faculity_app2/core/services/service_locator.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/anage_announcements_cubit.dart';
import 'package:faculity_app2/features/announcements/presentation/cubit/manage_announcements_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

class AddEditAnnouncementScreen extends StatefulWidget {
  final Announcement? announcement; // إذا كانت القيمة null، فهذه شاشة إضافة

  const AddEditAnnouncementScreen({super.key, this.announcement});

  @override
  State<AddEditAnnouncementScreen> createState() =>
      _AddEditAnnouncementScreenState();
}

class _AddEditAnnouncementScreenState extends State<AddEditAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  File? _selectedFile;

  bool get isEditMode => widget.announcement != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.announcement?.title);
    _contentController = TextEditingController(
      text: widget.announcement?.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final data = {
        'title': _titleController.text,
        'content': _contentController.text,
      };

      if (isEditMode) {
        // الـ API لا تدعم تعديل المرفق، لذا نرسل البيانات النصية فقط
        context.read<ManageAnnouncementsCubit>().updateAnnouncement(
          id: widget.announcement!.id,
          data: data,
        );
      } else {
        context.read<ManageAnnouncementsCubit>().addAnnouncement(
          data: data,
          filePath: _selectedFile?.path,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ManageAnnouncementsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'تعديل الإعلان' : 'إضافة إعلان جديد'),
        ),
        body: BlocConsumer<ManageAnnouncementsCubit, ManageAnnouncementsState>(
          listener: (context, state) {
            if (state is ManageAnnouncementsSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              Navigator.of(
                context,
              ).pop(true); // إرجاع true للإشارة إلى أن التحديث تم
            }
            if (state is ManageAnnouncementsFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          builder: (context, state) {
            final isLoading = state is ManageAnnouncementsLoading;
            return AbsorbPointer(
              absorbing: isLoading,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'العنوان'),
                      validator:
                          (value) => value!.isEmpty ? 'العنوان مطلوب' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(labelText: 'المحتوى'),
                      maxLines: 8,
                      validator:
                          (value) => value!.isEmpty ? 'المحتوى مطلوب' : null,
                    ),
                    const SizedBox(height: 20),
                    // عرض زر المرفقات فقط في وضع الإضافة
                    if (!isEditMode)
                      _AttachmentPicker(
                        selectedFile: _selectedFile,
                        onTap: _pickFile,
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('حفظ'),
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
}

class _AttachmentPicker extends StatelessWidget {
  final File? selectedFile;
  final VoidCallback onTap;
  const _AttachmentPicker({this.selectedFile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.attach_file),
          label: const Text('اختيار مرفق (اختياري)'),
        ),
        if (selectedFile != null) ...[
          const SizedBox(height: 10),
          Text(
            'الملف المختار: ${selectedFile!.path.split('/').last}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
