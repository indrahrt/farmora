import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_product_model.dart';

class ChatController {
  ChatController._();
  static final ChatController instance = ChatController._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateChatId(String productId, String buyerId, String sellerId) {
    final ids = [buyerId, sellerId]..sort();
    return "${productId}_${ids.join('_')}";
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatId,
    required ChatProductModel product,
    required String buyerId,
    required String sellerId,
    required String senderId,
    required String message,
    required Timestamp createdAt,
  }) async {
    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.set({
      'buyerId': buyerId,
      'sellerId': sellerId,
      'participants': [buyerId, sellerId],
      'product': product.toMap(),
      'lastMessage': message,
      'updatedAt': createdAt,
      'sellerName': product.sellerName,
      'sellerPhotoBase64': product.sellerPhotoBase64,
    }, SetOptions(merge: true));

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'message': message,
      'createdAt': createdAt,
    });
  }
}
