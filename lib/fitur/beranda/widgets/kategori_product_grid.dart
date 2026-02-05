import 'dart:convert';
import 'package:flutter/material.dart';
import '../../akun/models/product_model.dart';
import '../../akun/controller/product_controller.dart';

class KategoriProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  KategoriProductGrid({super.key, required this.products});

  final ProductController controller = ProductController();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= GAMBAR =================
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.memory(
                        base64Decode(product.imageBase64),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),

              /// ================= INFORMASI =================
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// NAMA PRODUK
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// HARGA
                      Text(
                        'Rp ${product.price}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D580B),
                        ),
                      ),

                      const Spacer(),

                      /// ================= SELLER INFO =================
                      FutureBuilder<Map<String, dynamic>?>(
                        future: controller.getSellerCached(product.ownerId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(height: 20);
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Text(
                              "Unknown seller",
                              style: TextStyle(fontSize: 11),
                            );
                          }

                          final seller = snapshot.data!;
                          final String name = seller['name'] ?? "Unknown";
                          final String? photo = seller['photoBase64'];

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    photo != null && photo.isNotEmpty
                                    ? MemoryImage(base64Decode(photo))
                                    : null,
                                child: photo == null
                                    ? const Icon(Icons.person, size: 12)
                                    : null,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
