import 'package:flutter/material.dart';

/// Configuração do tema da aplicação seguindo Material Design 3
class AppTheme {
  /// Retorna um ThemeData claro gerado a partir de uma cor seed
  static ThemeData lightTheme({Color seed = const Color(0xFF6750A4)}) {
    final scheme =
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,

      /// Configuração da AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: true,
        elevation: 2,
        surfaceTintColor: scheme.primary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onPrimary,
        ),
      ),

      /// Configuração dos botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      /// Configuração do Drawer e ListTiles para consistência visual
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        scrimColor: scheme.onSurface.withAlpha((0.28 * 255).round()),
        elevation: 8,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        iconColor: scheme.primary,
        textColor: scheme.onSurface,
        tileColor: scheme.surface,
      ),

      /// Configuração dos campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.error),
        ),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      ),

      /// Configuração dos cards
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: scheme.surface,
      ),

      /// Configuração do FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// Tema escuro gerado a partir da mesma cor seed
  static ThemeData darkTheme({Color seed = const Color(0xFF6750A4)}) {
    final scheme =
        ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        centerTitle: true,
        elevation: 1,
        surfaceTintColor: scheme.surface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: scheme.surface,
        scrimColor: scheme.onSurface.withAlpha((0.28 * 255).round()),
        elevation: 6,
      ),
    );
  }
}
