import 'package:go_router/go_router.dart';
import '../screens/inventory_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/', // Inicia aquí
  routes: [
    // 1. LA RUTA RAÍZ ES EL SPLASH
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),

    GoRoute(
      path: '/inventory',
      builder: (context, state) => const InventoryScreen(),
    ),
    
    GoRoute(
      path: '/edit/:sku',
      builder: (context, state) {
        final sku = state.pathParameters['sku']!;
        return EditProductScreen(sku: sku);
      },
    ),
  ],
);