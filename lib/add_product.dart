import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/product_model.dart';
import 'providers/product_provider.dart';

import 'services/notification_service.dart';
import 'services/storage_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      image: imageController.text.trim(),
    );

    final success = await context.read<ProductProvider>().addProduct(product);

    if (!mounted) return;

    if (success) {
      /// Simpan produk terakhir
      await StorageService.saveLastProduct(nameController.text.trim());

      /// Local Notification
      await NotificationService.instance.showNotification(
        title: "GlowMe",
        body:
            "${nameController.text.trim()} berhasil ditambahkan ke skincare kamu 💕",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan")),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<ProductProvider>().errorMessage ??
                "Gagal menambahkan produk",
          ),
        ),
      );
    }
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.pink.shade100),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFFF4A80), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffFFF8FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFE7EE),
        title: const Text(
          "Add Product",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: decoration("Product Name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama produk wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descriptionController,
                decoration: decoration("Description"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Deskripsi wajib diisi";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: imageController,
                decoration: decoration("Image URL"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "URL gambar wajib diisi";
                  }

                  if (!value.startsWith("http")) {
                    return "Masukkan URL gambar yang valid";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : saveProduct,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4A80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),

                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Save Product",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
