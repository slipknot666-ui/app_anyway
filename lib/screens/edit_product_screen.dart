import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/product_model.dart';
import '../providers/inventory_provider.dart';

class EditProductScreen extends StatefulWidget {
  final String sku; // Recibimos el ID del producto a editar

  const EditProductScreen({super.key, required this.sku});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  late TextEditingController _skuController;
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    // 1. Buscamos el producto en el Provider usando el SKU
    final provider = context.read<InventoryProvider>();
    final product = provider.getProductBySku(widget.sku);

    // Si por alguna razón no existe (error raro), regresamos
    if (product == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop(); 
      });
      // Inicializamos vacíos para evitar error de null antes del pop
      _skuController = TextEditingController();
      _nameController = TextEditingController();
      _costController = TextEditingController();
      _priceController = TextEditingController();
      _stockController = TextEditingController();
      return;
    }

    // 2. Llenamos los controladores con los datos existentes
    _skuController = TextEditingController(text: product.sku);
    _nameController = TextEditingController(text: product.name);
    _costController = TextEditingController(text: product.costPrice.toString());
    _priceController = TextEditingController(text: product.salePrice.toString());
    _stockController = TextEditingController(text: product.stock.toString());
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Creamos el objeto con los datos modificados
      final updatedProduct = Product(
        sku: _skuController.text, // El SKU se mantiene igual
        name: _nameController.text,
        costPrice: double.parse(_costController.text),
        salePrice: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
      );

      // Guardamos en el Provider
      context.read<InventoryProvider>().updateProduct(updatedProduct);

      // Mostramos mensaje y volvemos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cambios guardados exitosamente'),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
      
      context.pop(); // Regresar a la tabla
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Producto: ${widget.sku}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600), // Ancho máximo para desktop
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SKU (Deshabilitado / Solo lectura)
                    TextFormField(
                      controller: _skuController,
                      enabled: false, // NO SE PUEDE EDITAR EL ID
                      decoration: const InputDecoration(
                        labelText: 'SKU (No editable)',
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Nombre
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Costo y Venta
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _costController,
                            decoration: const InputDecoration(labelText: 'Costo', prefixText: '\$'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                            validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'P. Venta', prefixText: '\$'),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Requerido';
                              final price = double.tryParse(value) ?? 0;
                              final cost = double.tryParse(_costController.text) ?? 0;
                              if (price < cost) return 'Precio menor al costo';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Stock
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock Actual'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botón de Guardar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save_as),
                        label: const Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}