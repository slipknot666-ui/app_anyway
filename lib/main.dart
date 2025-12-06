import 'package:flutter/material.dart';
import 'screens/inventory_screen.dart'; 

void main() {
  runApp(const StockMasterApp());
}

class StockMasterApp extends StatelessWidget {
  const StockMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockMaster Desktop',
      debugShowCheckedModeBanner: false,
      
      // TEMA CORPORATIVO
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Azul profundo profesional
          brightness: Brightness.light,
        ),
        // Estilo de tarjetas
        cardTheme: const CardThemeData(
          elevation: 3,
          surfaceTintColor: Colors.white,
          margin: EdgeInsets.zero,
        ),
        // Estilo de Inputs (Formularios)
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        // Estilo de botones
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      
      home: const InventoryScreen(),
    );
  }
}