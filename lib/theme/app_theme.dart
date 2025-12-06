import 'package:flutter/material.dart';

class AppTheme {
  // Definimos los colores corporativos aquí para no repetirlos
  static const Color primaryColor = Color(0xFF0D47A1); // Azul Profundo

  static ThemeData getLight() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      
      // Configuración de Tarjetas
      cardTheme: const CardThemeData(
        elevation: 3,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.zero,
      ),
      
      // Configuración de Inputs
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      
      // Configuración de Botones
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}