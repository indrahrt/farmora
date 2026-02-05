import 'package:cloud_firestore/cloud_firestore.dart';
import '../../akun/models/product_model.dart';

class KategoriProductController {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> streamProdukByKategori(String kategori) {
    return _firestore
        .collection('products')
        .where('type', isEqualTo: kategori)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProductModel.fromMap(doc.data()))
              .toList();
        });
  }
}
