import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../models/product_model.dart';

class ProductController {
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ================= CURRENT USER =================
  User get currentUser => _auth.currentUser!;

  /// ================= PICK & COMPRESS IMAGE =================
  Future<String?> pickImageBase64() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final bytes = await File(picked.path).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final resized = img.copyResize(image, width: 400);
    final jpg = img.encodeJpg(resized, quality: 70);

    return base64Encode(jpg);
  }

  /// ================= SAVE PRODUCT =================
  Future<void> saveProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  /// ================= STREAM PRODUK USER =================
  Stream<QuerySnapshot> streamMyProducts() {
    return _firestore
        .collection('products')
        .where('ownerId', isEqualTo: currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// ================= SELLER CACHE (ANTI LAG) =================

  Map<String, Map<String, dynamic>> sellerCache = {};

  Future<Map<String, dynamic>?> getSellerCached(String ownerId) async {
    /// cek cache dulu
    if (sellerCache.containsKey(ownerId)) {
      return sellerCache[ownerId];
    }

    try {
      final doc = await _firestore.collection('users').doc(ownerId).get();

      /// USER ADA
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        sellerCache[ownerId] = data;

        return data;
      }
    } catch (_) {}

    /// fallback current user
    final userRecord = _auth.currentUser;

    if (userRecord != null && userRecord.uid == ownerId) {
      final fallback = {
        'name': userRecord.displayName ?? 'User',
        'photoBase64': null,
      };

      sellerCache[ownerId] = fallback;

      return fallback;
    }

    /// default
    return null;
  }
}
