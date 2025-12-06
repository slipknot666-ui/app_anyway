import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/inventory_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const StockMasterApp());
}

class StockMasterApp extends StatelessWidget {
  const StockMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Inyectamos el Provider en la cima del árbol
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      // 2. Usamos MaterialApp.router
      child: MaterialApp.router(
        title: 'Inventario 360',
        debugShowCheckedModeBanner: false,
        
        // Conexión del Router
        routerConfig: appRouter,
        
        // Conexión de los Temas (Claro y Oscuro)
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Usa la config de Windows (Claro/Oscuro)
      ),
    );
  }
}