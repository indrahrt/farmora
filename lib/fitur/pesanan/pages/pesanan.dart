import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: PesananPage()));

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPembeli = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 1. Toggle Switch Pembeli/Penjual
            _buildToggleSwitch(),
            
            // 2. Search Bar
            _buildSearchBar(),
            
            // 3. TabBar
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Pembayaran'),
                Tab(text: 'Pengantaran'),
                Tab(text: 'Selesai'),
              ],
            ),
            
            // 4. List Pesanan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildEmptyStateBanner(),
                  const SizedBox(height: 16),
                  _buildOrderCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _toggleButton("Sebagai Pembeli", isPembeli, () => setState(() => isPembeli = true)),
        const SizedBox(width: 10),
        _toggleButton("Sebagai Penjual", !isPembeli, () => setState(() => isPembeli = false)),
      ],
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? (isPembeli ? Colors.green : Colors.green) : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Pesanan',
          suffixIcon: const Icon(Icons.search, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _buildEmptyStateBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // Oval shape
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30, backgroundColor: Colors.orangeAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Belum ada pesanan 🍃", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("Ayo mulai belanja hasil tani terbaik!", style: TextStyle(fontSize: 11)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen, shape: const StadiumBorder()),
                  child: const Text("Mulai Belanja", style: TextStyle(color: Colors.white, fontSize: 10)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Toko Tani Perkasa", style: TextStyle(fontWeight: FontWeight.bold)),
          const Text("Verifikasi", style: TextStyle(color: Colors.green, fontSize: 10)),
          const Divider(),
          // Stepper Mini
          Row(
            children: [
              _stepCircle(true), _stepLine(false), _stepCircle(false), _stepLine(false), _stepCircle(false),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Selesaikan Pembayaran", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          Row(
            children: [
              Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image)),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Beras Premium", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Harga: Rp 65.000/5kg", style: TextStyle(fontSize: 12)),
                    Text("Total: Rp 130.000", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(onPressed: () {}, child: const Text("Batalkan", style: TextStyle(color: Colors.orange))),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Hubungi Petani", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _stepCircle(bool active) => CircleAvatar(radius: 6, backgroundColor: active ? Colors.orange : Colors.grey[300]);
  Widget _stepLine(bool active) => Expanded(child: Container(height: 2, color: active ? Colors.orange : Colors.grey[300]));
}