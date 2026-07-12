import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/product_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/product_card.dart';
import 'widgets/summary_card.dart';

import 'add_product.dart';
import 'edit_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        // Routine Page
        break;

      case 2:
        // Blog Page
        break;

      case 3:
        // Profile Page
        break;
    }
  }

  Future<void> _goToAddProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );

    if (!mounted) return;

    context.read<ProductProvider>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF8FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFE7EE),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "GlowMe",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              const HomeHeader(),

              const SizedBox(height: 20),

              /// SUMMARY CARD
              const SummaryCard(),

              const SizedBox(height: 30),

              /// TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Skincare",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  InkWell(
                    onTap: _goToAddProduct,

                    borderRadius: BorderRadius.circular(12),

                    child: Container(
                      padding: const EdgeInsets.all(8),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4A80),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// PRODUCT LIST
              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const SizedBox(
                      height: 190,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (provider.products.isEmpty) {
                    return const SizedBox(
                      height: 190,
                      child: Center(
                        child: Text(
                          "Belum ada produk",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 200,

                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,

                      itemCount: provider.products.length,

                      separatorBuilder: (_, __) => const SizedBox(width: 12),

                      itemBuilder: (context, index) {
                        final product = provider.products[index];

                        return ProductCard(
                          product: product,

                          /// EDIT
                          onEdit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProductPage(product: product),
                              ),
                            );

                            if (!mounted) return;

                            context.read<ProductProvider>().fetchProducts();
                          },

                          /// DELETE
                          onDelete: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Product"),
                                content: Text("Delete ${product.name} ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final success = await context
                                  .read<ProductProvider>()
                                  .deleteProduct(product.id!);

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? "Produk berhasil dihapus"
                                        : "Gagal menghapus produk",
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        backgroundColor: const Color(0xFFFFE7EE),

        selectedItemColor: const Color(0xFFFF4A80),

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "Routine",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: "Blog",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
