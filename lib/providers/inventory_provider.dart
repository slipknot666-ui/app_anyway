import 'package:flutter/material.dart';
import '../models/product_model.dart';

class InventoryProvider extends ChangeNotifier {
  // Lista privada
  final List<Product> _products = [];

  // Getter público
  List<Product> get products => _products;

  // 1. Agregar (Ya lo tenías)
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners(); 
  }

  // 2. NUEVO: Buscar producto por SKU (Para cargar el formulario de edición)
  Product? getProductBySku(String sku) {
    try {
      return _products.firstWhere((p) => p.sku == sku);
    } catch (e) {
      return null; // No existe
    }
  }

  // 3. NUEVO: Actualizar producto existente
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.sku == updatedProduct.sku);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners(); // ¡Avisar a la pantalla que se redibuje!
    }
  }

  // Validación
  bool existsSku(String sku) {
    return _products.any((p) => p.sku == sku);
  }

  // Métricas
  double get totalPotentialProfit {
    double total = 0;
    for (var p in _products) {
      total += (p.salePrice - p.costPrice) * p.stock;
    }
    return total;
  }
}