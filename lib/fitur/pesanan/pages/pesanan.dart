import 'package:flutter/material.dart';
import 'pembeli.dart';
import 'penjual.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
  bool isPembeli = true;
  late TabController _tabController;

  final Color forestGreen = const Color.fromARGB(255, 29, 88, 11);

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

  /// ================= AMBIL STATUS DARI TAB =================
  String? get currentStatus {
    switch (_tabController.index) {
      case 1:
        return 'dikemas';
      case 2:
        return 'dikirim';
      case 3:
        return 'selesai';
      default:
        return null; // semua
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          isPembeli ? "Pesanan Belanja" : "Kelola Penjualan",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          /// ROLE TOGGLE
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 16),
            child: _roleToggle(),
          ),

          /// TAB STATUS
          _tabBar(),

          /// CONTENT
          Expanded(
            child: isPembeli
                ? PesananPembeliPage(status: currentStatus)
                : PenjualPage(status: currentStatus),
          ),
        ],
      ),
    );
  }

  /// ================= ROLE TOGGLE =================
  Widget _roleToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton("Pembeli", isPembeli, () => _switchRole(true)),
          ),
          Expanded(
            child: _toggleButton(
              "Penjual",
              !isPembeli,
              () => _switchRole(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? forestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// ================= TAB BAR =================
  Widget _tabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        labelColor: forestGreen,
        unselectedLabelColor: Colors.grey,
        indicatorColor: forestGreen,
        tabs: const [
          Tab(text: "Semua"),
          Tab(text: "Dikemas"),
          Tab(text: "Kirim"),
          Tab(text: "Selesai"),
        ],
      ),
    );
  }
}
