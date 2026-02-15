import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String productId;

  final String productNama;
  final String productFoto;
  final int total;
  final String status;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.productId,
    required this.productNama,
    required this.productFoto,
    required this.total,
    required this.status,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderModel(
      id: doc.id,
      buyerId: data['buyerId'] ?? '',
      sellerId: data['sellerId'] ?? '',
      productId: data['productId'] ?? '',

      // 🔥 FIX NAMA
      productNama: data['productNama'] ?? '',

      // 🔥 FIX FOTO
      productFoto: data['productFoto'] ?? '',

      // 🔥 FIX TOTAL
      total: (data['total'] ?? 0) as int,

      status: data['status'] ?? 'menunggu',
    );
  }
}
