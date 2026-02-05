import 'dart:convert';
import 'package:flutter/material.dart';
import '../controller/beranda_product_controller.dart';
import '../../akun/models/product_model.dart';
import '../pages/detail_produk_page.dart';

class ProdukTerbaruSection extends StatelessWidget {
  final String searchKeyword;

  const ProdukTerbaruSection({super.key, required this.searchKeyword});

  final Color primaryColor = const Color(0xFF1D580B);

  @override
  Widget build(BuildContext context) {
    final controller = BerandaProductController();

    return StreamBuilder<List<ProductModel>>(
      stream: controller.streamProdukTerbaru(),
      builder: (context, snapshot) {
        /// LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        /// DATA KOSONG
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        /// 🔥 FILTER SEARCH REALTIME
        final products = snapshot.data!
            .where(
              (product) => product.name.toLowerCase().contains(searchKeyword),
            )
            .toList();

        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("Produk tidak ditemukan")),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Text(
                'Produk Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            /// GRID PRODUCT
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.92,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _productCard(context, product);
              },
            ),
          ],
        );
      },
    );
  }

  /// =========================================================
  /// 🔥 PRODUCT CARD (STYLE MARKETPLACE)
  /// =========================================================

  Widget _productCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailProductPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            /// IMAGE
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.memory(
                  base64Decode(product.imageBase64),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// INFO
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAMA PRODUK
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// HARGA
                  Text(
                    'Rp ${product.price}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// ⭐ RATING + TERJUAL
                  Row(
                    children: const [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 2),
                      Text('0.0', style: TextStyle(fontSize: 11)),
                      SizedBox(width: 6),
                      Text(
                        '• 0 terjual',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
