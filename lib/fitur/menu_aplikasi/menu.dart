import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Menggunakan skema warna hijau WhatsApp
        colorSchemeSeed: const Color(0xFF25D366),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  // List halaman agar tetap persisten di memory
  final List<Widget> _pages = [
    const Center(child: Text('Halaman Beranda')),
    const Center(child: Text('Halaman Pesanan')),
    const Center(child: Text('Halaman Kotak Masuk')),
    const Center(child: Text('Halaman Profil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack menjaga semua halaman tetap "hidup" di background
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF25D366), // Hijau WA
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 28,
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
