import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_product_model.dart';

class ChatRoomModel {
  final String id;
  final ChatProductModel product;
  final String buyerId;
  final String sellerId;
  final String lastMessage;
  final Timestamp updatedAt;

  ChatRoomModel({
    required this.id,
    required this.product,
    required this.buyerId,
    required this.sellerId,
    required this.lastMessage,
    required this.updatedAt,
  });
}
