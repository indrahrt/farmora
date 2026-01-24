import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: KotakMasukPage()));

class KotakMasukPage extends StatelessWidget {
  const KotakMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu-abu muda
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 1. Search Bar
            _buildSearchBar(),
            
            // 2. Tab Bar (Manual/Custom)
            _buildCustomTabBar(),
            
            // 3. List of Messages
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildChatCard(
                    "Halo, Kak 👋\nTerima kasih sudah menghubungi Toko Tani Perkasa. Ada yang bisa kami bantu terkait produk kami?",
                  ),
                  _buildChatCard(
                    "Pesanan Kakak sudah kami terima ✅\nSaat ini sedang kami siapkan untuk pengiriman.",
                  ),
                  _buildChatCard(
                    "Pesanan Kakak sudah kami kirim hari ini 🚚\nNomor resi akan otomatis muncul di aplikasi. Terima kasih sudah berbelanja di Toko Tani Perkasa 🌽",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Search Bar dengan border hitam bulat
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Cari Pesan',
            suffixIcon: Icon(Icons.search, color: Colors.black, size: 28),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Widget Tab Bar sederhana (Semua, Penjual, Belum Dibaca)
  Widget _buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tabItem("Semua", isActive: true),
          _tabItem("Penjual"),
          _tabItem("Belum Dibaca"),
        ],
      ),
    );
  }

  Widget _tabItem(String title, {bool isActive = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        if (isActive)
          Container(height: 2, width: 60, color: Colors.orange)
        else
          const SizedBox(height: 2),
      ],
    );
  }

  // Widget Kartu Chat sesuai gambar
  Widget _buildChatCard(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Toko
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.orange[50],
            ),
            child: const Icon(Icons.storefront, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          // Isi Pesan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Toko Tani Perkasa",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.verified, color: Colors.green[400], size: 16),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}