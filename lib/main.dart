// lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash.dart';

void main() {
  runApp(const AppEventos());
}

class AppEventos extends StatelessWidget {
  const AppEventos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventos Locais',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6750A4), // Roxo moderno
      ),
      home: const SplashScreen(),
    );
  }
}
