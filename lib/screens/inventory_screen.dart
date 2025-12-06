import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/product_model.dart';
import '../providers/inventory_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      // 1. CREAR EL OBJETO
      final newProduct = Product(
        sku: _skuController.text,
        name: _nameController.text,
        costPrice: double.parse(_costController.text),
        salePrice: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
      );

      // 2. LLAMAR AL PROVIDER
      context.read<InventoryProvider>().addProduct(newProduct);

      // 3. LIMPIEZA UI
      _skuController.clear();
      _nameController.clear();
      _costController.clear();
      _priceController.clear();
      _stockController.clear();
      
      Navigator.of(context).pop(); 
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto agregado correctamente'),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Producto'),
        content: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(labelText: 'SKU / Código *'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Requerido';
                          // LÓGICA DE VALIDACIÓN CON PROVIDER
                          final provider = context.read<InventoryProvider>();
                          if (provider.existsSku(value)) {
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(labelText: 'Costo', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (v) => (v == null || v.isEmpty) ? 'Falta costo' : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(labelText: 'P. Venta', prefixText: '\$'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Falta precio';
                          final price = double.tryParse(value) ?? 0;
                          final cost = double.tryParse(_costController.text) ?? 0;
                          if (price < cost) return 'Precio < Costo';
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton.icon(
            onPressed: _submitProduct, 
            icon: const Icon(Icons.save),
            label: const Text('Guardar')
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ESCUCHAR CAMBIOS DEL PROVIDER
    final provider = context.watch<InventoryProvider>();
    final products = provider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Inventario'),
        // BOTÓN DE VOLVER AL DASHBOARD
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // Navega a la ruta raíz (Dashboard)
        ),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Existencias Actuales', style: Theme.of(context).textTheme.headlineSmall),
                Chip(
                  avatar: const Icon(Icons.monetization_on, size: 18),
                  label: Text('Ganancia Potencial: \$${provider.totalPotentialProfit.toStringAsFixed(2)}'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: products.isEmpty 
                ? const Center(child: Text('No hay productos. Agrega el primero.'))
                : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      columns: const [
                        DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Producto', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Costo', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('P. Venta', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                        DataColumn(label: Text('Ganancia', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                      ],
                      rows: products.map((product) {
  final margin = (product.salePrice - product.costPrice) * product.stock;
  
  return DataRow(
    // ESTA LÍNEA HACE LA MAGIA:
    onSelectChanged: (selected) {
      if (selected == true) {
        // Navegamos a la ruta de edición pasando el SKU
        context.push('/edit/${product.sku}');
      }
    },
    
    cells: [
      DataCell(Text(product.sku, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(product.name)),
      // ... el resto de tus celdas iguales ...
      DataCell(Text('\$${product.costPrice.toStringAsFixed(2)}')),
      DataCell(Text('\$${product.salePrice.toStringAsFixed(2)}')),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: product.stock < 5 
                ? Colors.red.withValues(alpha: 0.1) 
                : Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: product.stock < 5 ? Colors.red : Colors.green, width: 0.5)
          ),
          child: Text(
             product.stock.toString(),
             style: TextStyle(color: product.stock < 5 ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
          ),
        )
      ),
      DataCell(Text('\$${margin.toStringAsFixed(2)}')),
    ]
  );
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