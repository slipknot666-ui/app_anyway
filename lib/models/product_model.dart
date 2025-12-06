class Product {
  final String sku;       // Identificador único
  final String name;      // Nombre
  final double costPrice; // Precio de compra
  final double salePrice; // Precio de venta
  final int stock;        // Cantidad

  Product({
    required this.sku,
    required this.name,
    required this.costPrice,
    required this.salePrice,
    required this.stock,
  });
}