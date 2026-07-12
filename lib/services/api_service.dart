import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import '../models/user_model.dart';

class ApiService {
  // ================= USER =================

  static const String baseUrl =
      "https://6a508976c576c846dcb9840b.mockapi.io/users";

  // ================= PRODUCT =================

  static const String productUrl =
      "https://6a51d03ac576c846dcba8a68.mockapi.io/products";

  static const _headers = {"Content-Type": "application/json"};

  // ==========================================================
  // USER
  // ==========================================================

  Future<List<UserModel>> getUsers() async {
    final response = await http
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => UserModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil data user");
  }

  Future<UserModel> createUser(UserModel user) async {
    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: _headers,
          body: jsonEncode(user.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Gagal membuat akun");
  }

  Future<void> updatePassword(String id, String password) async {
    final response = await http
        .put(
          Uri.parse("$baseUrl/$id"),
          headers: _headers,
          body: jsonEncode({"password": password}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception("Gagal mengubah password");
    }
  }

  // ==========================================================
  // PRODUCT
  // ==========================================================

  Future<List<ProductModel>> getProducts() async {
    final response = await http
        .get(Uri.parse(productUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => ProductModel.fromJson(e)).toList();
    }

    throw Exception("Gagal mengambil data produk");
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await http
        .post(
          Uri.parse(productUrl),
          headers: _headers,
          body: jsonEncode(product.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Gagal menambahkan produk");
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await http
        .put(
          Uri.parse("$productUrl/${product.id}"),
          headers: _headers,
          body: jsonEncode(product.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Gagal mengubah produk");
  }

  Future<void> deleteProduct(String id) async {
    final response = await http
        .delete(Uri.parse("$productUrl/$id"))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus produk");
    }
  }
}
