import 'package:cloud_firestore/cloud_firestore.dart';

class AlamatModel {
  final String id;
  final String nama;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String desa;
  final String alamatLengkap;

  AlamatModel({
    required this.id,
    required this.nama,
    required this.provinsi,
    required this.kabupaten,
    required this.kecamatan,
    required this.desa,
    required this.alamatLengkap,
  });

  factory AlamatModel.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AlamatModel(
      id: doc.id,
      nama: data['nama'] ?? '',
      provinsi: data['provinsi'] ?? '',
      kabupaten: data['kabupaten'] ?? '',
      kecamatan: data['kecamatan'] ?? '',
      desa: data['desa'] ?? '',
      alamatLengkap: data['alamatLengkap'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'provinsi': provinsi,
      'kabupaten': kabupaten,
      'kecamatan': kecamatan,
      'desa': desa,
      'alamatLengkap': alamatLengkap,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
