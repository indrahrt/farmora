import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ TAMBAHAN
import '../../akun/models/product_model.dart';
import '../controller/cart_controller.dart';
import '../../kotak_masuk/model/chat_product_model.dart';
import '../../kotak_masuk/pages/chat_detail_page.dart';
import '../../akun/controller/product_controller.dart';
import '../../akun/controller/alamat_controller.dart';
import '../../akun/pages/alamat.dart';
import '../../pesanan/pages/buat_pesanan_page.dart';

class DetailProductPage extends StatelessWidget {
  final ProductModel product;

  DetailProductPage({super.key, required this.product});

  final ProductController productController = ProductController();
  final AlamatController alamatController = AlamatController();

  // ✅ TAMBAHAN: USER LOGIN ASLI
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final Color primaryColor = const Color(0xFF1D580B);
  final Color priceColor = const Color(0xFF2E7D32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: Hero(
                tag: 'product-${product.name}',
                child: Image.memory(
                  base64Decode(product.imageBase64),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rp ${product.price}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: priceColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoBar(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(thickness: 0.5),
                  ),
                  const Text(
                    "Deskripsi Produk",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.8,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(thickness: 0.5),
                  ),
                  _buildReviewSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ================= BOTTOM =================
      bottomSheet: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 30,
          top: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: productController.getSellerCached(product.ownerId),
              builder: (context, snapshot) {
                return _buildIconButton(Icons.chat_bubble_outline_rounded, () {
                  if (!snapshot.hasData || snapshot.data == null) return;

                  final seller = snapshot.data!;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailPage(
                        // ✅ FIX UTAMA DI SINI
                        buyerId: currentUserId,
                        sellerId: product.ownerId,
                        product: ChatProductModel(
                          productId: product.createdAt.millisecondsSinceEpoch
                              .toString(),
                          name: product.name,
                          imageBase64: product.imageBase64,
                          sellerId: product.ownerId,
                          sellerName: seller['name'] ?? 'Penjual',
                          sellerPhotoBase64: seller['photoBase64'],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
            const SizedBox(width: 12),
            _buildIconButton(Icons.add_shopping_cart_rounded, () {
              final cart = CartController.instance;

              if (cart.isProductInCart(product)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Produk sudah ada dalam keranjang"),
                  ),
                );
              } else {
                cart.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Produk berhasil masuk ke keranjang"),
                  ),
                );
              }
            }),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final adaAlamat = await alamatController.hasAlamat();

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    if (!adaAlamat) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AlamatPage()),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BuatPesananPage(product: product),
                      ),
                    );
                  },
                  child: const Text("Beli Sekarang"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(Icons.star_rounded, "0.0", Colors.amber),
          _buildInfoItem(Icons.shopping_bag_outlined, "0 Terjual", Colors.blue),
          _buildInfoItem(
            Icons.inventory_2_outlined,
            "Stok: ${product.stock}",
            product.stock > 0 ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ulasan Pembeli",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text("Belum ada ulasan"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(14),
      ),
      child: IconButton(icon: Icon(icon), onPressed: onTap),
    );
  }
}
