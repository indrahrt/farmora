import 'package:flutter/material.dart';

import 'pesanan_pembeli_page.dart';

class PesananPembeliTabPage extends StatelessWidget {
  const PesananPembeliTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Pesanan Saya",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF1D580B),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF1D580B),
            tabs: [
              Tab(text: "Dikemas"),
              Tab(text: "Dikirim"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PesananPembeliPage(status: 'dikemas'),
            PesananPembeliPage(status: 'dikirim'),
            PesananPembeliPage(status: 'selesai'),
          ],
        ),
      ),
    );
  }
}
