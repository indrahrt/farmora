import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/chat_product_model.dart';
import 'chat_detail_page.dart';

class KotakMasukPage extends StatefulWidget {
  const KotakMasukPage({super.key});

  @override
  State<KotakMasukPage> createState() => _KotakMasukPageState();
}

class _KotakMasukPageState extends State<KotakMasukPage> {
  final Color primaryGreen = const Color.fromARGB(255, 29, 88, 11);
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Kotak Masuk",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _buildMessageList(),
    );
  }

  // ================= CHAT LIST =================
  Widget _buildMessageList() {
    if (currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where(
            'participants',
            arrayContains: currentUserId, // 🔥 FILTER USER LOGIN
          )
          .orderBy('updatedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Belum ada percakapan"));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final chatProduct = ChatProductModel.fromMap(data['product']);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatDetailPage(
                      product: chatProduct,
                      buyerId: data['buyerId'],
                      sellerId: data['sellerId'],
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    // FOTO TOKO
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: primaryGreen.withValues(
                        alpha: 0.1,
                      ), // ✅ FIX
                      backgroundImage:
                          data['sellerPhotoBase64'] != null &&
                              data['sellerPhotoBase64'].isNotEmpty
                          ? MemoryImage(base64Decode(data['sellerPhotoBase64']))
                          : null,
                      child: data['sellerPhotoBase64'] == null
                          ? Icon(Icons.store, color: primaryGreen)
                          : null,
                    ),
                    const SizedBox(width: 12),

                    // NAMA TOKO & PESAN TERAKHIR
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['sellerName'] ?? 'Toko',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['lastMessage'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
