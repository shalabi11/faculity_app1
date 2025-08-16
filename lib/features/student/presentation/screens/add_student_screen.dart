// // lib/features/admin/presentation/screens/add_edit_student_screen.dart

// import 'dart:io';
// import 'package:faculity_app2/core/services/service_locator.dart';
// import 'package:faculity_app2/features/student/domain/entities/student.dart';
// import 'package:faculity_app2/features/student/presentation/cubit/manage_student_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// // الويدجت الرئيسي وظيفته فقط توفير الـ Cubit وتمرير الطالب (إن وجد)
// class AddEditStudentScreen extends StatelessWidget {
//   // أصبحنا نستقبل طالبًا اختياريًا. إذا لم يكن null، فنحن في وضع التعديل
//   final Student? student;
//   const AddEditStudentScreen({super.key, this.student});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<ManageStudentCubit>(),
//       child: _AddEditStudentView(student: student), // تمرير الطالب للواجهة
//     );
//   }
// }

// // الويدجت الداخلي الذي يحتوي على الواجهة والمنطق
// class _AddEditStudentView extends StatefulWidget {
//   final Student? student;
//   const _AddEditStudentView({this.student});

//   @override
//   State<_AddEditStudentView> createState() => _AddEditStudentViewState();
// }

// class _AddEditStudentViewState extends State<_AddEditStudentView> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _universityIdController;
//   late TextEditingController _fullNameController;
//   late TextEditingController _motherNameController;
//   late TextEditingController _birthDateController;
//   late TextEditingController _birthPlaceController;
//   late TextEditingController _departmentController;
//   late TextEditingController _highSchoolGpaController;
//   File? _profileImage;

//   // متغير لمعرفة إذا كنا في وضع التعديل
//   bool get _isEditMode => widget.student != null;

//   @override
//   void initState() {
//     super.initState();
//     // تعبئة الحقول ببيانات الطالب إذا كنا في وضع التعديل
//     _universityIdController = TextEditingController(
//       text: widget.student?.universityId ?? '',
//     );
//     _fullNameController = TextEditingController(
//       text: widget.student?.fullName ?? '',
//     );
//     _motherNameController = TextEditingController(
//       text: widget.student?.motherName ?? '',
//     );
//     _birthDateController = TextEditingController(
//       text: widget.student?.birthDate ?? '',
//     );
//     _birthPlaceController = TextEditingController(
//       text: widget.student?.birthPlace ?? '',
//     );
//     _departmentController = TextEditingController(
//       text: widget.student?.department ?? '',
//     );
//     _highSchoolGpaController = TextEditingController(
//       text: widget.student?.highSchoolGpa.toString() ?? '',
//     );
//   }

//   @override
//   void dispose() {
//     _universityIdController.dispose();
//     _fullNameController.dispose();
//     _motherNameController.dispose();
//     _birthDateController.dispose();
//     _birthPlaceController.dispose();
//     _departmentController.dispose();
//     _highSchoolGpaController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _profileImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       final studentData = {
//         'university_id': _universityIdController.text,
//         'full_name': _fullNameController.text,
//         'mother_name': _motherNameController.text,
//         'birth_date': _birthDateController.text,
//         'birth_place': _birthPlaceController.text,
//         'department': _departmentController.text,
//         'high_school_gpa': _highSchoolGpaController.text,
//       };

//       // التحقق من الوضع الحالي (إضافة أم تعديل)
//       if (_isEditMode) {
//         context.read<ManageStudentCubit>().updateStudent(
//           id: widget.student!.id,
//           studentData: studentData,
//         );
//       } else {
//         context.read<ManageStudentCubit>().addStudent(
//           studentData: studentData,
//           image: _profileImage,
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // تغيير العنوان بناءً على الوضع
//         title: Text(_isEditMode ? 'تعديل بيانات الطالب' : 'إضافة طالب جديد'),
//       ),
//       body: BlocListener<ManageStudentCubit, ManageStudentState>(
//         listener: (context, state) {
//           if (state is ManageStudentSuccess) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             Navigator.pop(context, true); // إرجاع true للنجاح
//           } else if (state is ManageStudentFailure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: ListView(
//               children: [
//                 // ... (جميع حقول الـ TextFormField تبقى كما هي)
//                 TextFormField(
//                   controller: _universityIdController,
//                   decoration: const InputDecoration(labelText: 'الرقم الجامعي'),
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 // TextFormField(
//                 //   controller: _fullNameController,
//                 //   decoration: const InputDecoration(labelText: 'الاسم الكامل'),
//                 //   validator:
//                 //       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 // ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _motherNameController,
//                   decoration: const InputDecoration(labelText: 'اسم الأم'),
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _birthDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'تاريخ الميلاد (YYYY-MM-DD)',
//                   ),
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _birthPlaceController,
//                   decoration: const InputDecoration(labelText: 'مكان الولادة'),
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _departmentController,
//                   decoration: const InputDecoration(labelText: 'القسم'),
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _highSchoolGpaController,
//                   decoration: const InputDecoration(labelText: 'معدل الثانوية'),
//                   keyboardType: TextInputType.number,
//                   validator:
//                       (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
//                 ),
//                 const SizedBox(height: 24),
//                 // لا نسمح بتعديل الصورة حاليًا لتبسيط الأمر
//                 if (!_isEditMode) _buildImagePicker(),
//                 const SizedBox(height: 24),
//                 BlocBuilder<ManageStudentCubit, ManageStudentState>(
//                   builder: (context, state) {
//                     if (state is ManageStudentLoading) {
//                       return const Center(child: LoadingList ());
//                     }
//                     return ElevatedButton(
//                       onPressed: _submitForm,
//                       // تغيير نص الزر بناءً على الوضع
//                       child: Text(_isEditMode ? 'حفظ التعديلات' : 'حفظ الطالب'),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePicker() {
//     return Column(
//       children: [
//         if (_profileImage != null)
//           Image.file(
//             _profileImage!,
//             height: 150,
//             width: 150,
//             fit: BoxFit.cover,
//           ),
//         TextButton.icon(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.image),
//           label: Text(
//             _profileImage == null ? 'اختيار صورة شخصية' : 'تغيير الصورة',
//           ),
//         ),
//       ],
//     );
//   }
// }
