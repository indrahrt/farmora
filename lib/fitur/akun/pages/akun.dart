import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../../login/pages/login.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final Color primaryColor = const Color.fromARGB(255, 29, 88, 11);

  // Getter untuk mendapatkan data user terbaru dari Firebase Auth
  User? get user => FirebaseAuth.instance.currentUser;

  // ✅ TAMBAHAN: nama dari Firestore (fallback)
  String? firestoreName;

  @override
  void initState() {
    super.initState();
    _refreshUser();
    _loadNameFromFirestore(); // ✅ TAMBAHAN
  }

  /// Fungsi untuk menarik data terbaru dari server Firebase
  Future<void> _refreshUser() async {
    try {
      await user?.reload();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Gagal memperbarui profil: $e");
    }
  }

  /// ✅ TAMBAHAN: Ambil nama dari Firestore (register manual)
  Future<void> _loadNameFromFirestore() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          firestoreName = doc['name'];
        });
      }
    } catch (e) {
      debugPrint("Gagal mengambil nama Firestore: $e");
    }
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            ListTile(
              leading: Icon(Icons.storefront, color: primaryColor),
              title: const Text("Menjual (Input Produk)"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined, color: primaryColor),
              title: const Text("Alamat Saya"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet_outlined,
                color: primaryColor,
              ),
              title: const Text("Saldo"),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Keluar", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () => _showSettingsMenu(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _refreshUser();
          await _loadNameFromFirestore(); // ✅ refresh Firestore juga
        },
        color: primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Profil
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? Icon(Icons.person, size: 45, color: primaryColor)
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // ✅ fallback berlapis (Google → Firestore → default)
                            user?.displayName ??
                                firestoreName ??
                                "Pengguna Farmora",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?.email ?? "-",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              const Text(
                "Toko Saya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Grid Produk
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Container(
                            height: 8,
                            width: 60,
                            color: Colors.grey[100],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 8,
                            width: 40,
                            color: Colors.green[50],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
