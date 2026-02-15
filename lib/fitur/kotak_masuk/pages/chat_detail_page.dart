import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/chat_controller.dart';
import '../model/chat_product_model.dart';

class ChatDetailPage extends StatefulWidget {
  final ChatProductModel product;
  final String buyerId;
  final String sellerId;

  const ChatDetailPage({
    super.key,
    required this.product,
    required this.buyerId,
    required this.sellerId,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController messageController = TextEditingController();

  late final String chatId;
  late final String currentUserId;
  late final String otherUserId; // 🔥 LAWAN CHAT

  final Color forestGreen = const Color(0xFF1D580B);

  @override
  void initState() {
    super.initState();

    currentUserId = FirebaseAuth.instance.currentUser!.uid;

    otherUserId = currentUserId == widget.buyerId
        ? widget.sellerId
        : widget.buyerId;

    chatId = ChatController.instance.generateChatId(
      widget.product.productId,
      widget.buyerId,
      widget.sellerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildHeader(),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildInput(),
        ],
      ),
    );
  }

  // ================= HEADER =================
  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: forestGreen.withValues(alpha: 0.1),
            backgroundImage:
                widget.product.sellerPhotoBase64 != null &&
                    widget.product.sellerPhotoBase64!.isNotEmpty
                ? MemoryImage(base64Decode(widget.product.sellerPhotoBase64!))
                : null,
            child: widget.product.sellerPhotoBase64 == null
                ? Icon(Icons.person, color: forestGreen)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.product.sellerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ================= MESSAGES =================
  Widget _buildMessages() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: ChatController.instance.getMessages(chatId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        if (messages.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada pesan",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isMe = msg['senderId'] == currentUserId;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? forestGreen : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  msg['message'],
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= INPUT =================
  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik pesan...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: forestGreen,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    final text = messageController.text.trim();
                    if (text.isEmpty) return;

                    await ChatController.instance.sendMessage(
                      chatId: chatId,
                      product: widget.product,
                      buyerId: widget.buyerId,
                      sellerId: widget.sellerId,
                      senderId: currentUserId,
                      message: text,
                      createdAt: Timestamp.now(),
                    );

                    messageController.clear();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
