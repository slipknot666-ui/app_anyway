import 'package:flutter/material.dart';
import '../models/product_model.dart';

class InventoryProvider extends ChangeNotifier {
  // Lista privada para proteger los datos
  final List<Product> _products = [];

  // Getter público (solo lectura)
  List<Product> get products => _products;

  // Acción: Agregar Producto
  void addProduct(Product product) {
    _products.add(product);
    // ¡Avisar a todos los widgets que escuchen que hubo un cambio!
    notifyListeners(); 
  }

  // Validación: Comprobar si existe el SKU
  bool existsSku(String sku) {
    return _products.any((p) => p.sku == sku);
  }

  // Métricas: Calcular ganancia total (Opcional, pero útil para dashboard)
  double get totalPotentialProfit {
    double total = 0;
    for (var p in _products) {
      total += (p.salePrice - p.costPrice) * p.stock;
    }
    return total;
  }
}