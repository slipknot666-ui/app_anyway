import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/inventory_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos al provider para actualizar las tarjetas si cambian los datos
    final provider = context.watch<InventoryProvider>();
    final products = provider.products;

    // Cálculos rápidos
    final totalProducts = products.length;
    final lowStockCount = products.where((p) => p.stock < 5).length;
    final totalValue = products.fold(0.0, (sum, p) => sum + (p.salePrice * p.stock));

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard - Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido de nuevo', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            
            // FILA DE TARJETAS DE RESUMEN (KPIs)
            Row(
              children: [
                _KpiCard(
                  title: 'Total Productos',
                  value: totalProducts.toString(),
                  icon: Icons.inventory_2,
                  color: Colors.blue,
                ),
                const SizedBox(width: 20),
                _KpiCard(
                  title: 'Stock Bajo (Alerta)',
                  value: lowStockCount.toString(),
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange,
                  isAlert: lowStockCount > 0,
                ),
                const SizedBox(width: 20),
                _KpiCard(
                  title: 'Valor Inventario',
                  value: '\$${totalValue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text('Accesos Rápidos', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 15),

            // BOTÓN GRANDE PARA IR AL INVENTARIO
            SizedBox(
              height: 150,
              width: 300,
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () => context.go('/inventory'), // Navegación con GoRouter
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: 40, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 10),
                        const Text('Gestionar Inventario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text('Ver tabla completa, agregar o editar', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para las tarjetas de métricas
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(
                    value, 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: isAlert ? Colors.red : Theme.of(context).colorScheme.onSurface,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}