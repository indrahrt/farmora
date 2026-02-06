import 'package:flutter/material.dart';
import '../widgets/product_section.dart';
import 'kategori_page.dart';
import 'artikel.dart';
import 'cart.dart'; // halaman keranjang
import '../controller/cart_controller.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final Color primaryColor = const Color(0xFF1D580B);
  final TextEditingController searchController = TextEditingController();
  String keyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              await Future.delayed(const Duration(seconds: 1)),
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderWithCart(),
                _buildCategories(context),
                ProdukTerbaruSection(searchKeyword: keyword),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER + SEARCH + CART =================

  Widget _buildHeaderWithCart() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    keyword = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Cari Buah dan Sayur Segar...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// ===== ICON CART + BADGE (INI PENAMBAHANNYA) =====
          ListenableBuilder(
            listenable: CartController.instance,
            builder: (context, _) {
              final totalItem = CartController.instance.totalItem;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KeranjangPage(),
                    ),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _iconButton(Icons.shopping_cart_outlined),
                    if (totalItem > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$totalItem',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, size: 24, color: Colors.black87),
    );
  }

  // ================= KATEGORI =================

  Widget _buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _categoryItem(
            context,
            Icons.apple_rounded,
            'Buah',
            'Buah',
            Colors.redAccent,
          ),
          _categoryItem(
            context,
            Icons.eco_rounded,
            'Sayur',
            'Sayur',
            Colors.green,
          ),
          _categoryItem(
            context,
            Icons.article_rounded,
            'Artikel',
            'artikel',
            Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(
    BuildContext context,
    IconData icon,
    String label,
    String kategori,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              if (kategori == 'artikel') {
                return const ArtikelPage();
              }
              return KategoriPage(kategori: kategori);
            },
          ),
        );
      },
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
