import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quick_entry/services/hive_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final Box _settingsBox = HiveService.settingsBox;

  ThemeNotifier() : super(ThemeMode.system){
    _loadTheme();
  }

  void _loadTheme() {
    final themeValue = _settingsBox.get(_themeKey, defaultValue: ThemeMode.system.index) as int;
    state = ThemeMode.values[themeValue];
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _settingsBox.put(_themeKey, mode.index);
  }
}
