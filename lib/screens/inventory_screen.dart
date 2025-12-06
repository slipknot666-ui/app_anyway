import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Lista que simula la base de datos local
  final List<Product> _products = [];
  
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de texto
  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void dispose() {
    // Limpiamos los controladores al cerrar la pantalla
    _skuController.dispose();
    _nameController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  // Lógica para agregar producto
  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _products.add(Product(
          sku: _skuController.text,
          name: _nameController.text,
          costPrice: double.parse(_costController.text),
          salePrice: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
        ));
      });
      
      // Limpiar formulario y cerrar diálogo
      _skuController.clear();
      _nameController.clear();
      _costController.clear();
      _priceController.clear();
      _stockController.clear();
      
      Navigator.of(context).pop(); // Cerrar el diálogo
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto agregado correctamente'),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  // Diálogo con formulario validado
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: SizedBox(
          width: 600, // Ancho optimizado para escritorio
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // FILA 1: SKU y Nombre
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(labelText: 'SKU / Código *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          // Validación: SKU único
                          if (_products.any((p) => p.sku == value)) {
                            return 'SKU duplicado';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nombre del Producto *'),
                        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                
                // FILA 2: Costo, Precio y Stock
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(labelText: 'Costo', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (v) => (v == null || v.isEmpty) ? 'Falta costo' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'P. Venta', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        // VALIDACIÓN CRÍTICA DE NEGOCIO
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Falta precio';
                          final price = double.tryParse(value) ?? 0;
                          final cost = double.tryParse(_costController.text) ?? 0;
                          
                          if (price < cost) {
                            return 'Error: Precio < Costo';
                          }
                          return null;
                        },
                      ),
                    ),
                     const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _stockController,
                        decoration: const InputDecoration(labelText: 'Stock'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancelar')
          ),
          FilledButton.icon(
            onPressed: _addProduct, 
            icon: const Icon(Icons.save),
            label: const Text('Guardar')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StockMaster - Gestión de Inventario')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        label: const Text('Agregar Producto'),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Existencias Actuales', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            
            // TABLA DE DATOS
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      // AQUÍ ESTÁ TU CORRECCIÓN: WidgetStateProperty
                      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                      columns: const [
                        DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Producto', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Costo', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('P. Venta', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('Ganancia Total', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                      ],
                      rows: _products.map((product) {
                        final margin = (product.salePrice - product.costPrice) * product.stock;
                        return DataRow(cells: [
                          DataCell(Text(product.sku, style: const TextStyle(fontWeight: FontWeight.w500))),
                          DataCell(Text(product.name)),
                          DataCell(Text('\$${product.costPrice.toStringAsFixed(2)}')),
                          DataCell(Text('\$${product.salePrice.toStringAsFixed(2)}')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.stock < 5 ? Colors.red[50] : Colors.green[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: product.stock < 5 ? Colors.red : Colors.green,
                                  width: 0.5
                                )
                              ),
                              child: Text(
                                product.stock.toString(),
                                style: TextStyle(
                                  color: product.stock < 5 ? Colors.red[900] : Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ),
                          DataCell(Text('\$${margin.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[700]))),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}