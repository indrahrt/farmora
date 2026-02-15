import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId;
  final String message;
  final Timestamp createdAt;

  ChatMessageModel({
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'message': message, 'createdAt': createdAt};
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      senderId: map['senderId'],
      message: map['message'],
      createdAt: map['createdAt'],
    );
  }
}
