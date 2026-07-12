import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _lastProductKey = "last_product";
  static const String _lastUpdateKey = "last_update";

  /// Simpan nama produk terakhir
  static Future<void> saveLastProduct(String productName) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_lastProductKey, productName);

    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// Ambil nama produk terakhir
  static Future<String?> getLastProduct() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_lastProductKey);
  }

  /// Ambil waktu terakhir update
  static Future<String?> getLastUpdate() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_lastUpdateKey);
  }

  /// Hapus data
  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_lastProductKey);
    await prefs.remove(_lastUpdateKey);
  }
}
