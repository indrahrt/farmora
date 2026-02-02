import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String type;
  final int stock;
  final int price;
  final String description;
  final String imageBase64;
  final String ownerId;
  final Timestamp createdAt;

  ProductModel({
    required this.name,
    required this.type,
    required this.stock,
    required this.price,
    required this.description,
    required this.imageBase64,
    required this.ownerId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'stock': stock,
      'price': price,
      'description': description,
      'imageBase64': imageBase64,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }

  /// OPTIONAL: kalau nanti mau ambil balik dari Firestore
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      stock: map['stock'] ?? 0,
      price: map['price'] ?? 0,
      description: map['description'] ?? '',
      imageBase64: map['imageBase64'] ?? '',
      ownerId: map['ownerId'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
