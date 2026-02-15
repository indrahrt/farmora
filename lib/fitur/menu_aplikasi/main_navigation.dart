import 'package:farmora/fitur/kotak_masuk/pages/kotak_masuk.dart';
import 'package:farmora/fitur/pesanan/pages/pesanan.dart';
import 'package:flutter/material.dart';
import '../beranda/pages/beranda.dart';
import '../../fitur/akun/pages/akun.dart';

class MenuNavigation extends StatefulWidget {
  /// 🔥 TAMBAHAN: agar bisa buka tab tertentu
  final int initialIndex;

  const MenuNavigation({
    super.key,
    this.initialIndex = 0, // default ke beranda
  });

  @override
  State<MenuNavigation> createState() => _MenuNavigationState();
}

class _MenuNavigationState extends State<MenuNavigation> {
  /// pakai late karena akan diisi dari parameter
  late int _currentIndex;

  final List<Widget> _pages = [
    const Beranda(),
    const PesananPage(),
    const KotakMasukPage(),
    const ProfilPage(),
  ];

  @override
  void initState() {
    super.initState();

    /// 🔥 ambil index dari luar
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: const Color.fromARGB(255, 29, 88, 11),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              activeIcon: Icon(Icons.mail),
              label: 'Kotak Masuk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}
