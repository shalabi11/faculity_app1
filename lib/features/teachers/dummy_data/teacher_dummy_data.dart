// lib/features/teachers/dummy_data/teacher_dummy_data.dart

import 'package:faculity_app2/features/courses/domain/entities/course_entity.dart';
import 'package:faculity_app2/features/schedule/domain/entities/schedule_entry.dart';
import 'package:faculity_app2/features/teachers/domain/entities/teacher.dart';
import 'package:faculity_app2/features/announcements/domain/entities/announcement.dart';

// 1. بيانات لملف الدكتور الشخصي (teacher_profile_screen.dart)
final TeacherEntity dummyLoggedInTeacher = TeacherEntity(
  id: 1,
  fullName: 'محمد نور',
  motherName: 'آمنة',
  birthDate: '1980-08-15',
  birthPlace: 'اللاذقية',
  academicDegree: 'دكتوراه',
  degreeSource: 'جامعة دمشق',
  department: 'هندسة البرمجيات',
  position: 'أستاذ مساعد',
);

// 2. بيانات لمقررات الدكتور (teacher_courses_screen.dart)
final List<CourseEntity> dummyTeacherCourses = [
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
];

// 3. بيانات لجدول دوام الدكتور (teacher_schedule_screen.dart)
final List<ScheduleEntity> dummyTeacherSchedule = [
  ScheduleEntity(
    id: 1,
    courseName: 'قواعد البيانات 2',
    classroomName: 'المدرج الأول',
    teacherName: 'محمد نور',
    type: 'theory',
    day: 'الأحد',
    startTime: '08:00',
    endTime: '10:00',
    year: 'الثالثة',
  ),
  ScheduleEntity(
    id: 2,
    courseName: 'الشبكات الحاسوبية',
    classroomName: 'القاعة 305',
    teacherName: 'محمد نور',
    type: 'theory',
    day: 'الثلاثاء',
    startTime: '12:00',
    endTime: '14:00',
    year: 'الثالثة',
  ),
];

// 4. بيانات للإعلانات العامة (teacher_announcements_screen.dart)
final List<Announcement> dummyGeneralAnnouncements = [
  Announcement(
    id: 1,
    title: 'تأجيل محاضرة',
    content:
        'تم تأجيل محاضرة قواعد البيانات 2 ليوم الأحد إلى موعد يحدد لاحقاً.',
    // userId: 1,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Announcement(
    id: 2,
    title: 'اجتماع هام',
    content:
        'اجتماع لأعضاء الهيئة التدريسية يوم الخميس الساعة 1 ظهراً في قاعة الاجتماعات.',
    // userId: 1,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
