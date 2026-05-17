import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectone/core/app_theme.dart';
import 'package:projectone/models/product.dart';
import 'package:projectone/providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController      = TextEditingController();
  final _priceController      = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController   = TextEditingController();
  final _imageController      = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      title:       _titleController.text.trim(),
      price:       double.tryParse(_priceController.text.trim()) ?? 0.0,
      description: _descriptionController.text.trim(),
      category:    _categoryController.text.trim(),
      image:       _imageController.text.trim(),
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.addProduct(product);

    if (context.mounted) {
      if (provider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white),
                SizedBox(width: 10),
                Text('Product added successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF065F46),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${provider.errorMessage}'),
            backgroundColor: AppTheme.dangerText,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSurface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Product'),
            Text(
              'Fill in the details below',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Form Card ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.borderLight, width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FormField(
                          label: 'PRODUCT TITLE',
                          controller: _titleController,
                          hint: 'e.g. Fjallraven Backpack',
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Title is required' : null,
                        ),
                        const SizedBox(height: 16),
                        _FormField(
                          label: 'PRICE (USD)',
                          controller: _priceController,
                          hint: 'e.g. 49.99',
                          keyboardType: TextInputType.number,
                          prefixText: '\$ ',
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Price is required';
                            if (double.tryParse(v) == null) return 'Enter a valid number';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _FormField(
                          label: 'DESCRIPTION',
                          controller: _descriptionController,
                          hint: 'Describe the product…',
                          maxLines: 4,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Description is required' : null,
                        ),
                        const SizedBox(height: 16),
                        _FormField(
                          label: 'CATEGORY',
                          controller: _categoryController,
                          hint: 'e.g. electronics',
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Category is required' : null,
                        ),
                        const SizedBox(height: 16),
                        _FormField(
                          label: 'IMAGE URL',
                          controller: _imageController,
                          hint: 'https://…  (optional)',
                          keyboardType: TextInputType.url,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Submit Button ──
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: provider.isLoading ? null : _submit,
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//Reusable Form Field Widget

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? Function(String?)? validator;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            hintStyle: const TextStyle(
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}