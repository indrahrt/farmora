import 'dart:convert';
import 'package:flutter/material.dart';
import '../../akun/models/product_model.dart';
import '../../akun/controller/product_controller.dart';
import '../pages/detail_produk_page.dart';

class KategoriProductGrid extends StatefulWidget {
  final List<ProductModel> products;

  const KategoriProductGrid({super.key, required this.products});

  @override
  State<KategoriProductGrid> createState() => _KategoriProductGridState();
}

class _KategoriProductGridState extends State<KategoriProductGrid> {
  final ProductController controller = ProductController();
  final TextEditingController searchController = TextEditingController();

  late List<ProductModel> filteredProducts;

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
  }

  void _searchProduct(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredProducts = widget.products;
      } else {
        filteredProducts = widget.products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(keyword.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ================= SEARCH BAR =================
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: _searchProduct,
              decoration: InputDecoration(
                hintText: "Cari produk favoritmu...",
                hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1D580B)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          searchController.clear();
                          _searchProduct('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        /// ================= EMPTY STATE =================
        if (filteredProducts.isEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search_off_rounded, size: 64, color: Colors.black38),
                SizedBox(height: 12),
                Text(
                  "Produk tidak ditemukan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        else
          /// ================= GRID PRODUK =================
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),

                  /// ================= TAP KE DETAIL =================
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
                          child: ClipRRect(
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
                        ),

                        /// ================= INFORMASI =================
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Text(
                                  'Rp ${product.price}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1D580B),
                                  ),
                                ),
                                const Spacer(),

                                /// SELLER INFO
                                FutureBuilder<Map<String, dynamic>?>(
                                  future: controller.getSellerCached(
                                    product.ownerId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const SizedBox(height: 20);
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return const Text(
                                        "Unknown seller",
                                        style: TextStyle(fontSize: 11),
                                      );
                                    }

                                    final seller = snapshot.data!;
                                    final String name =
                                        seller['name'] ?? "Unknown";
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
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 12,
                                                )
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
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
