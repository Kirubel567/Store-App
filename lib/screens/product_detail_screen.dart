import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectone/core/app_theme.dart';
import 'package:projectone/providers/product_provider.dart';
import 'package:projectone/screens/edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    // loadProduct now checks local list first — no stale API data
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false)
            .loadProduct(widget.productId));
  }

  Future<void> _navigateToEdit(BuildContext context, provider) async {
    final product = provider.selectedProduct;
    if (product == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProductScreen(product: product),
      ),
    );

    if (context.mounted) {
      Provider.of<ProductProvider>(context, listen: false)
          .loadProduct(widget.productId);
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, ProductProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete product?',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerText,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteProduct(widget.productId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgSurface,
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                  color: AppTheme.navyDark, strokeWidth: 2),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text('Error: ${provider.errorMessage}',
                  style: const TextStyle(color: AppTheme.dangerText)),
            );
          }

          final product = provider.selectedProduct;
          if (product == null) {
            return const Center(child: Text('Product not found.'));
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // ── Image / AppBar ──
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: AppTheme.navyDark,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppTheme.navyDark, size: 18),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: const Color(0xFFF4F4F4),
                        padding: const EdgeInsets.all(32),
                        child: product.image.isNotEmpty
                            ? Image.network(
                                product.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 64,
                                  color: Color(0xFFCCCCCC),
                                ),
                              )
                            : const Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: Color(0xFFCCCCCC),
                              ),
                      ),
                    ),
                  ),

                  // ── Product Info ──
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppTheme.bgSurface,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppTheme.categoryColor(
                                      product.category),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.categoryTextColor(
                                        product.category),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'ID: #${product.id}',
                                style: const TextStyle(
                                    fontSize: 12, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                              height: 1.25,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.navyDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                              height: 1, color: AppTheme.borderLight),
                          const SizedBox(height: 20),
                          const Text(
                            'DESCRIPTION',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppTheme.textSecondary,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Action Bar 
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    MediaQuery.of(context).padding.bottom + 12,
                  ),
                  decoration: const BoxDecoration(
                    color: AppTheme.bgSurface,
                    border: Border(
                      top: BorderSide(
                          color: AppTheme.borderLight, width: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _navigateToEdit(context, provider),
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit Product'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.dangerLight,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppTheme.dangerBorder, width: 0.5),
                        ),
                        child: IconButton(
                          onPressed: () =>
                              _confirmDelete(context, provider),
                          icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppTheme.dangerText,
                              size: 22),
                          tooltip: 'Delete product',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}