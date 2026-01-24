import 'package:flutter/material.dart';

void main() {
  runApp(const Beranda());
}

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildCategories(),
                _buildStoreSection(),
                _buildBestSellerHeader(),
                _buildProductGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 1. Search Bar Section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Cari Toko Terdekat',
            icon: Icon(Icons.search, color: Colors.black),
            suffixIcon: Icon(Icons.mic, color: Colors.black),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // 2. Category Icons
  Widget _buildCategories() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _categoryItem(Icons.shopping_basket, 'Belanja'),
          _categoryItem(Icons.percent, 'Promo'),
          _categoryItem(Icons.handyman, 'Alat Tani'),
          _categoryItem(Icons.article, 'Artikel'),
        ],
      ),
    );
  }

  Widget _categoryItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  // 3. Store Banner Section (Horizontal Scroll)
  Widget _buildStoreSection() {
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.verified, color: Colors.green),
          title: Text(
            'Toko Terjamin Farmora',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Toko pilihan dengan kualitas terpercaya',
            style: TextStyle(fontSize: 12),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _storeCard('Toko Tani Makmur', '4.8', 'Lembang'),
              _storeCard('Toko Tani Sejahtera', '4.7', 'Subang'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _storeCard(String name, String rating, String loc) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.orange),
        title: Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '⭐ $rating | $loc',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen[200],
            elevation: 0,
          ),
          child: const Text(
            'Lihat',
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
        ),
      ),
    );
  }

  // 4. Best Seller Header
  Widget _buildBestSellerHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.orange),
          SizedBox(width: 8),
          Text(
            'Best Seller',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 5. Product Grid
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _productCard('Bawang Merah', 'Rp 14.000/Kg');
      },
    );
  }

  Widget _productCard(String title, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '⭐ 4.8 | 1.2K Terjual',
                  style: TextStyle(fontSize: 8),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[200],
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 25),
                    ),
                    child: const Text(
                      'Tambah',
                      style: TextStyle(fontSize: 9, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
