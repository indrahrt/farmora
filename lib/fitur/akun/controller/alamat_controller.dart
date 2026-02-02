import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/alamat_models.dart';

class AlamatController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  /// 🔥 SIMPAN
  Future<void> simpanAlamat(AlamatModel alamat) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('alamat')
        .add(alamat.toMap());
  }

  /// 🔥 UPDATE
  Future<void> updateAlamat(AlamatModel alamat) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('alamat')
        .doc(alamat.id)
        .update(alamat.toMap());
  }

  /// 🔥 DELETE
  Future<void> hapusAlamat(String id) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('alamat')
        .doc(id)
        .delete();
  }

  /// 🔥 STREAM REALTIME (INI YANG PENTING)
  Stream<List<AlamatModel>> streamAlamat() {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('alamat')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AlamatModel.fromFirestore(doc))
              .toList(),
        );
  }
}
