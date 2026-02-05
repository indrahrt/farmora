import 'package:cloud_firestore/cloud_firestore.dart';
import '../../akun/models/product_model.dart';

class BerandaProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SEMUA PRODUK - TERBARU (SEMUA PENJUAL)
  Stream<List<ProductModel>> streamProdukTerbaru() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data()))
              .toList(),
        );
  }
}
