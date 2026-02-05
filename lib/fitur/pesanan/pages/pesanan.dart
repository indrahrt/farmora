import 'package:flutter/material.dart';

enum OrderStatus { payment, delivery, done }

class Order {
  final String toko;
  final String produk;
  final int total;
  OrderStatus status;

  Order({
    required this.toko,
    required this.produk,
    required this.total,
    required this.status,
  });
}

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
  bool isPembeli = true;
  late TabController _tabController;
  String keyword = "";

  final List<Order> _orders = [
    Order(
      toko: "Toko Tani Perkasa",
      produk: "Beras Premium",
      total: 130000,
      status: OrderStatus.payment,
    ),
    Order(
      toko: "Toko Tani Perkasa",
      produk: "Beras Premium",
      total: 130000,
      status: OrderStatus.delivery,
    ),
    Order(
      toko: "Toko Tani Rahmat",
      produk: "Beras Organik",
      total: 150000,
      status: OrderStatus.done,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _switchRole(bool pembeli) {
    setState(() => isPembeli = pembeli);
  }

  List<Order> get filteredOrders {
    List<Order> list = _orders;
    if (keyword.isNotEmpty) {
      list = list
          .where(
            (o) =>
                o.toko.toLowerCase().contains(keyword.toLowerCase()) ||
                o.produk.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    switch (_tabController.index) {
      case 1:
        list = list.where((o) => o.status == OrderStatus.payment).toList();
        break;
      case 2:
        list = list.where((o) => o.status == OrderStatus.delivery).toList();
        break;
      case 3:
        list = list.where((o) => o.status == OrderStatus.done).toList();
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              isPembeli ? "Pesanan Pembeli" : "Pesanan Penjual",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _roleToggle(),
            _searchBar(),
            _tabBar(),
            Expanded(
              child: filteredOrders.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, i) => _orderCard(filteredOrders[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _toggleButton("Sebagai Pembeli", isPembeli, () => _switchRole(true)),
        const SizedBox(width: 10),
        _toggleButton("Sebagai Penjual", !isPembeli, () => _switchRole(false)),
      ],
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (v) => setState(() => keyword = v),
        decoration: InputDecoration(
          hintText: "Cari Pesanan",
          suffixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: _tabController,
      onTap: (_) => setState(() {}),
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
      tabs: const [
        Tab(text: "Semua"),
        Tab(text: "Pembayaran"),
        Tab(text: "Pengantaran"),
        Tab(text: "Selesai"),
      ],
    );
  }

  Widget _emptyState() {
    final bool pembeli = isPembeli;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          border: Border.all(
            color: pembeli ? Colors.lightGreen : Colors.orange,
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/icon_tidak_ada_pesanan.png",
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Belum ada pesanan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(pembeli ? "🍃" : "🐮"),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    pembeli
                        ? "Ayo mulai belanja hasil tani terbaik!"
                        : "Ayo mulai jual hasil tani terbaik!",
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),

                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pembeli
                            ? Colors.lightGreen
                            : Colors.orange,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        pembeli ? "Mulai Belanja" : "Mulai Berjualan",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.toko,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          _stepper(order.status),
          const SizedBox(height: 10),
          Text(
            order.produk,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("Total: Rp ${order.total}"),
          const SizedBox(height: 10),
          _actionButton(order),
        ],
      ),
    );
  }

  Widget _stepper(OrderStatus status) {
    return Row(
      children: [
        _stepCircle(status.index >= 0),
        _stepLine(status.index >= 1),
        _stepCircle(status.index >= 1),
        _stepLine(status.index >= 2),
        _stepCircle(status.index >= 2),
      ],
    );
  }

  Widget _stepCircle(bool active) {
    return CircleAvatar(
      radius: 6,
      backgroundColor: active ? Colors.orange : Colors.grey[300],
    );
  }

  Widget _stepLine(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? Colors.orange : Colors.grey[300],
      ),
    );
  }

  Widget _actionButton(Order order) {
    if (order.status == OrderStatus.payment) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => setState(() => order.status = OrderStatus.done),
            child: const Text("Batalkan"),
          ),
          ElevatedButton(
            onPressed: () =>
                setState(() => order.status = OrderStatus.delivery),
            child: const Text("Bayar"),
          ),
        ],
      );
    }

    if (order.status == OrderStatus.delivery) {
      return Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () => setState(() => order.status = OrderStatus.done),
          child: const Text("Konfirmasi Terima"),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: OutlinedButton(onPressed: () {}, child: const Text("Beri Ulasan")),
    );
  }
}
