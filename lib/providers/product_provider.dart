import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ==========================
  // GET PRODUCTS
  // ==========================
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _api.getProducts();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================
  // ADD PRODUCT
  // ==========================
  Future<bool> addProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.createProduct(product);

      // Refresh dari MockAPI
      await fetchProducts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================
  // UPDATE PRODUCT
  // ==========================
  Future<bool> updateProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.updateProduct(product);

      // Refresh data terbaru
      await fetchProducts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================
  // DELETE PRODUCT
  // ==========================
  Future<bool> deleteProduct(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _api.deleteProduct(id);

      // Refresh data terbaru
      await fetchProducts();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==========================
  // CLEAR ERROR
  // ==========================
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
