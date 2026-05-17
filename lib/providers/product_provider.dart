import 'package:flutter/material.dart';
import 'package:projectone/models/product.dart';
import 'package:projectone/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  // Local ID counter for newly created products.
  int _localIdCounter = 1000;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  //GET ALL
  Future<void> loadProducts() async {
    _setLoading(true);
    _setError(null);
    try {
      final apiProducts = await ApiService.getProducts();
      // Preserve any locally created products (id >= 1000) across refreshes
      final localOnly = _products.where((p) => p.id >= 1000).toList();
      _products = [...apiProducts, ...localOnly];
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //GET SINGLE
  // Always check local list first
  Future<void> loadProduct(int id) async {
    _setError(null);

    final localMatch = _findById(id);
    if (localMatch != null) {
      _selectedProduct = localMatch;
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final fetched = await ApiService.getProduct(id);
      _selectedProduct = fetched;
      _products.add(fetched);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //CREATE
  Future<void> addProduct(Product product) async {
    _setLoading(true);
    _setError(null);
    try {
      final int assignedId = _localIdCounter++;

      final localProduct = Product(
        id: assignedId,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
      );

      _products.add(localProduct);
      notifyListeners();

      ApiService.createProduct(product).catchError((_) {});
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // UPDATE 
  Future<void> updateProduct(int id, Product product) async {
    _setLoading(true);
    _setError(null);
    try {
      final updatedProduct = Product(
        id: id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
      );

      // Update local list
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      if (_selectedProduct?.id == id) {
        _selectedProduct = updatedProduct;
      }

      notifyListeners();

      if (id < 1000) {
        ApiService.updateProduct(id, product).catchError((_) {});
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //DELETE
  Future<void> deleteProduct(int id) async {
    _setLoading(true);
    _setError(null);
    try {
      _products.removeWhere((p) => p.id == id);

      if (_selectedProduct?.id == id) {
        _selectedProduct = null;
      }

      notifyListeners();
      if (id < 1000) {
        ApiService.deleteProduct(id).catchError((_) {});
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  //Helper
  Product? _findById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
