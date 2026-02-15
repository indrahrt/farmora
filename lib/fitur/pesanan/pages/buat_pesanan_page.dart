import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../akun/models/product_model.dart';
import '../../akun/controller/alamat_controller.dart';
import '../../akun/models/alamat_models.dart';
import '../../akun/controller/product_controller.dart';
import '../../menu_aplikasi/main_navigation.dart';

class BuatPesananPage extends StatefulWidget {
  final ProductModel product;
  final int initialQty;

  const BuatPesananPage({
    super.key,
    required this.product,
    this.initialQty = 1,
  });

  @override
  State<BuatPesananPage> createState() => _BuatPesananPageState();
}

class _BuatPesananPageState extends State<BuatPesananPage> {
  final AlamatController alamatController = AlamatController();
  final ProductController productController = ProductController();

  AlamatModel? selectedAlamat;
  int qty = 1;
  bool isLoading = false;

  final Color primaryColor = const Color(0xFF1D580B);
  final Color secondaryColor = const Color(0xFFF1F8E9);
  final Color accentColor = const Color(0xFF2E7D32);

  int get totalHarga => widget.product.price * qty;

  @override
  void initState() {
    super.initState();
    qty = widget.initialQty;
  }

  // ================= SIMPAN PESANAN =================
  Future<void> _prosesBuatPesanan() async {
    if (selectedAlamat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pilih alamat pengiriman terlebih dahulu!"),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance.collection('orders').add({
        'buyerId': user.uid,
        'sellerId': widget.product.ownerId,
        'productNama': widget.product.name,
        'productFoto': widget.product.imageBase64,
        'price': widget.product.price,
        'qty': qty,
        'total': totalHarga,
        'alamat': selectedAlamat!.alamatLengkap,
        'status': 'menunggu',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // 🔥 REDIRECT KE MAIN NAVIGATION → TAB PESANAN
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const MenuNavigation(initialIndex: 1),
        ),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal membuat pesanan: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          "Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: StreamBuilder<List<AlamatModel>>(
        stream: alamatController.streamAlamat(),
        builder: (context, snapshot) {
          final alamatList = snapshot.data ?? [];

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _sectionHeader(
                      Icons.location_on_rounded,
                      "Alamat Pengiriman",
                    ),
                    _alamatSection(alamatList),
                    const SizedBox(height: 20),

                    _sectionHeader(Icons.shopping_bag_rounded, "Detail Produk"),
                    _combinedOrderCard(),
                    const SizedBox(height: 20),

                    _sectionHeader(Icons.payment_rounded, "Metode Pembayaran"),
                    _metodeBayar(),
                  ],
                ),
              ),
              _bottomTotal(),
            ],
          );
        },
      ),
    );
  }

  // ================= UI PART =================

  Widget _sectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _alamatSection(List<AlamatModel> list) {
    return Container(
      decoration: _boxStyle(),
      child: list.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Belum ada alamat pengiriman"),
            )
          : Column(
              children: list.map((alamat) {
                return RadioListTile<AlamatModel>(
                  value: alamat,
                  groupValue: selectedAlamat,
                  onChanged: (val) {
                    setState(() => selectedAlamat = val);
                  },
                  activeColor: primaryColor,
                  title: Text(
                    alamat.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    alamat.alamatLengkap,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _combinedOrderCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _boxStyle(),
      child: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: productController.getSellerCached(widget.product.ownerId),
            builder: (context, snapshot) {
              final seller = snapshot.data;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: secondaryColor.withValues(alpha: 0.6),
                child: Row(
                  children: [
                    Icon(Icons.storefront, size: 18, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      seller?['name'] ?? "Memuat toko...",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    base64Decode(widget.product.imageBase64),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${widget.product.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: accentColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _qtyBtn(Icons.remove, () {
                            if (qty > 1) setState(() => qty--);
                          }),
                          SizedBox(
                            width: 40,
                            child: Text(
                              "$qty",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _qtyBtn(
                            Icons.add,
                            () => setState(() => qty++),
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isPrimary ? primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _metodeBayar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxStyle(),
      child: Row(
        children: [
          Icon(Icons.payments_outlined, color: primaryColor),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cash On Delivery (COD)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Bayar saat barang sampai",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _bottomTotal() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Tagihan",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                Text(
                  "Rp $totalHarga",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : _prosesBuatPesanan,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Buat Pesanan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxStyle() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
