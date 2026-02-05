import 'package:flutter/material.dart';
import '../controller/kategori_product_controller.dart';
import '../widgets/kategori_product_grid.dart';
import '../../akun/models/product_model.dart';

class KategoriPage extends StatelessWidget {
  final String kategori;

  KategoriPage({super.key, required this.kategori});

  final controller = KategoriProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// background abu muda biar card kelihatan floating
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        /// TITLE
        title: Text(
          kategori,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),

        /// 🔥 icon search dihapus sesuai request
      ),

      body: Column(
        children: [
          /// garis tipis bawah appbar
          Container(height: 1, color: Colors.grey.withValues(alpha: 0.1)),

          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: controller.streamProdukByKategori(kategori),
              builder: (context, snapshot) {
                /// loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1D580B),
                      strokeWidth: 3,
                    ),
                  );
                }

                /// kosong
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }

                /// GRID PRODUK
                return RefreshIndicator(
                  color: const Color(0xFF1D580B),
                  onRefresh: () async {},
                  child: KategoriProductGrid(products: snapshot.data!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ================= EMPTY STATE =================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_mall_outlined,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada produk',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nantikan koleksi terbaru kami segera.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
