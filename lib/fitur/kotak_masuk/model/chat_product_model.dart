class ChatProductModel {
  final String productId;
  final String name;
  final String imageBase64;
  final String sellerId;
  final String sellerName;
  final String? sellerPhotoBase64;

  ChatProductModel({
    required this.productId,
    required this.name,
    required this.imageBase64,
    required this.sellerId,
    required this.sellerName,
    this.sellerPhotoBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageBase64': imageBase64,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerPhotoBase64': sellerPhotoBase64,
    };
  }

  factory ChatProductModel.fromMap(Map<String, dynamic> map) {
    return ChatProductModel(
      productId: map['productId'],
      name: map['name'],
      imageBase64: map['imageBase64'],
      sellerId: map['sellerId'],
      sellerName: map['sellerName'],
      sellerPhotoBase64: map['sellerPhotoBase64'],
    );
  }
}
