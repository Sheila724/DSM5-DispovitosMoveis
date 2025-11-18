// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeController.init();
  runApp(const AppEventos());
}

class AppEventos extends StatefulWidget {
  const AppEventos({super.key});

  @override
  State<AppEventos> createState() => _AppEventosState();
}

class _AppEventosState extends State<AppEventos> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eventos Locais',
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
