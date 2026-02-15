import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';
import 'riview.dart';

class PesananPembeliPage extends StatelessWidget {
  final String? status; // untuk tab (dikemas, dikirim, selesai)

  const PesananPembeliPage({super.key, this.status});

  // ================= STREAM =================
  Stream<List<OrderModel>> _getOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    Query query = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: user.uid);

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map(OrderModel.fromFirestore).toList(),
    );
  }

  // ================= STATUS COLOR =================
  Color _statusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange.shade700;
      case 'dikemas':
        return Colors.blue.shade700;
      case 'dikirim':
        return Colors.purple.shade700;
      case 'selesai':
        return const Color(0xFF1D580B);
      case 'batal':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  // ================= HAPUS ORDER =================
  Future<void> _hapusOrder(String id) async {
    await FirebaseFirestore.instance.collection('orders').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: StreamBuilder<List<OrderModel>>(
        stream: _getOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan sistem"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Daftar pesanan kosong",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return _orderCard(context, orders[index]);
            },
          );
        },
      ),
    );
  }

  // ================= CARD PESANAN =================
  Widget _orderCard(BuildContext context, OrderModel order) {
    final bool canCancel =
        order.status == 'menunggu' || order.status == 'dikemas';
    final bool isFinished = order.status == 'selesai';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), // ✅ FIX
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Rincian Pesanan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(
                      order.status,
                    ).withValues(alpha: 0.1), // ✅ FIX
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(order.status),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // BODY
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: order.productFoto.isNotEmpty
                      ? Image.memory(
                          base64Decode(order.productFoto),
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 75,
                          height: 75,
                          color: Colors.grey.shade100,
                          child: const Icon(Icons.inventory_2_outlined),
                        ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productNama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Rp ${order.total}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1D580B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FOOTER
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                if (canCancel)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Batalkan Pesanan"),
                            content: const Text(
                              "Pesanan yang dibatalkan tidak bisa dikembalikan.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Tidak"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Ya, Batalkan"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _hapusOrder(order.id);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade300),
                        foregroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Batalkan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                if (canCancel) const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isFinished) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewPage(
                              orderId: order.id,
                              productName: order.productNama,
                              productFoto: order.productFoto,
                              sellerId: order.sellerId,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D580B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isFinished ? "Beri Ulasan" : "Hubungi Penjual",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
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
