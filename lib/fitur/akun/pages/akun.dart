import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/settings.dart';
import 'edit_produk_page.dart'; // Pastikan import ke halaman edit

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final Color primaryColor = const Color(0xFF1D580B);
  User? get user => FirebaseAuth.instance.currentUser;

  String? firestoreName;
  String? firestorePhotoBase64;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _initProfile();
  }

  Future<void> _initProfile() async {
    final uid = user?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          firestoreName = doc.data()?['name'];
          firestorePhotoBase64 = doc.data()?['photoBase64'];
        });
      }
    }
    if (mounted) {
      setState(() => loading = false);
    }
  }

  Widget _buildProductCard(Map<String, dynamic> data, String docId) {
    final imageBase64 = data['imageBase64'];
    return InkWell(
      onTap: () {
        // Klik kartu langsung ke halaman edit
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditProdukPage(docId: docId, initialData: data),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9F8),
                    image: imageBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(imageBase64)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageBase64 == null
                      ? const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rp ${data['price']}",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => SettingsBottomSheet.show(context, primaryColor),
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: primaryColor,
              onRefresh: _initProfile, // Memanggil ulang fungsi initProfile
              child: SingleChildScrollView(
                // Physics ini memastikan fitur tarik-ke-bawah selalu aktif
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: firestorePhotoBase64 != null
                          ? MemoryImage(base64Decode(firestorePhotoBase64!))
                          : null,
                      child: firestorePhotoBase64 == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      firestoreName ?? "Pengguna Farmora",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Produk Toko Saya",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('ownerId', isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text("Belum ada produk."),
                            ),
                          );
                        }
                        final docs = snapshot.data!.docs;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: docs.length,
                          itemBuilder: (context, i) => _buildProductCard(
                            docs[i].data() as Map<String, dynamic>,
                            docs[i].id,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}
