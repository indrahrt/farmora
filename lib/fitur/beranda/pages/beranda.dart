import 'package:flutter/material.dart';
import '../widgets/product_section.dart';
import 'kategori_page.dart';
import 'artikel.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Beranda()));
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final Color primaryColor = const Color(0xFF1D580B);

  /// ✅ CONTROLLER SEARCH
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

                /// 🔥 PRODUK TERBARU + SEARCH FILTER
                ProdukTerbaruSection(searchKeyword: keyword),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

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

                /// 🔥 SEARCH REALTIME
                onChanged: (value) {
                  setState(() {
                    keyword = value.toLowerCase();
                  });
                },

                decoration: const InputDecoration(
                  hintText: 'Cari pupuk, alat, atau toko...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.green),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _iconButton(Icons.shopping_cart_outlined),
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
