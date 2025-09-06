// lib/features/head_of_department/dummy_data/hod_dummy_data.dart
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';

// 1. بيانات لإدارة المدرسين (manage_teachers_screen.dart)
final List<TeacherEntity> dummyDepartmentTeachers = [
  TeacherEntity(
    id: 1,
    fullName: 'محمد نور',
    motherName: 'آمنة',
    birthDate: '1980-08-15',
    birthPlace: 'اللاذقية',
    academicDegree: 'دكتوراه',
    degreeSource: 'جامعة دمشق',
    department: 'هندسة البرمجيات',
    position: 'رئيس قسم',
  ),
  TeacherEntity(
    id: 2,
    fullName: 'علي الأحمد',
    motherName: 'فاطمة',
    birthDate: '1982-01-20',
    birthPlace: 'حلب',
    academicDegree: 'دكتوراه',
    degreeSource: 'جامعة حلب',
    department: 'هندسة البرمجيات',
    position: 'أستاذ',
  ),
  TeacherEntity(
    id: 3,
    fullName: 'ريم صالح',
    motherName: 'عائشة',
    birthDate: '1988-11-30',
    birthPlace: 'دمشق',
    academicDegree: 'ماجستير',
    degreeSource: 'جامعة تشرين',
    department: 'هندسة البرمجيات',
    position: 'محاضر',
  ),
];

// 2. بيانات لإدارة المقررات (manage_course_screen.dart)
final List<CourseEntity> dummyDepartmentCourses = [
  CourseEntity(
    id: 1,
    name: 'قواعد البيانات 2',
    department: 'هندسة البرمجيات',
    year: 'الثالثة',
  ),
  CourseEntity(
    id: 2,
    name: 'الشبكات الحاسوبية',
    department: 'هندسة البرمجيات',
    year: 'الثالثة',
  ),
  CourseEntity(
    id: 3,
    name: 'هندسة البرمجيات 1',
    department: 'هندسة البرمجيات',
    year: 'الثانية',
  ),
  CourseEntity(
    id: 4,
    name: 'الخوارزميات وبنى المعطيات',
    department: 'هندسة البرمجيات',
    year: 'الثانية',
  ),
  CourseEntity(
    id: 5,
    name: 'أمن المعلومات',
    department: 'هندسة البرمجيات',
    year: 'الرابعة',
  ),
];
