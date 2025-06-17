import 'package:bloc/bloc.dart';
import 'package:faculity_app2/core/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences sharedPreferences;
  // مفتاح ثابت لحفظ واختيار الثيم في ذاكرة الهاتف
  static const String _themeKey = 'app_theme';

  ThemeCubit({required this.sharedPreferences})
    // الحالة الابتدائية هي الوضع الفاتح
    : super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  // دالة لقراءة الثيم المحفوظ عند بدء التطبيق
  void _loadTheme() {
    // اقرأ القيمة، وإذا لم تكن موجودة، اعتبرها false (الوضع الفاتح)
    final isDark = sharedPreferences.getBool(_themeKey) ?? false;
    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  // دالة لتبديل الثيم وحفظ الاختيار الجديد
  Future<void> toggleTheme() async {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // حفظ الاختيار الجديد في ذاكرة الهاتف
    await sharedPreferences.setBool(_themeKey, newMode == ThemeMode.dark);
    emit(ThemeState(themeMode: newMode));
  }
}
