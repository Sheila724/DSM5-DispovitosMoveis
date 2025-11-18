import 'package:flutter/material.dart';
import '../../shared/services/theme_service.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  static Future<void> init() async {
    final saved = await ThemeService.loadThemeMode();
    mode.value = saved;
  }

  static void setMode(ThemeMode m) {
    mode.value = m;
    ThemeService.saveThemeMode(m);
  }
}
