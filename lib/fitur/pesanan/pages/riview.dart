import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewPage extends StatefulWidget {
  final String orderId;
  final String productName;
  final String productFoto;
  final String sellerId;

  const ReviewPage({
    super.key,
    required this.orderId,
    required this.productName,
    required this.productFoto,
    required this.sellerId,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int rating = 5;
  final TextEditingController reviewController = TextEditingController();
  bool loading = false;

  Future<void> _submitReview() async {
    setState(() => loading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 1. Simpan Review
      await FirebaseFirestore.instance
          .collection('reviews')
          .doc(widget.orderId) // 1 ORDER = 1 REVIEW
          .set({
            'orderId': widget.orderId,
            'buyerId': uid,
            'sellerId': widget.sellerId,
            'productName': widget.productName,
            'rating': rating,
            'review': reviewController.text,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // 2. Update status order -> selesai
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderId)
          .update({'status': 'selesai'});

      // ✅ FIXED: Cek apakah widget masih ada di screen sebelum navigasi/pop
      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ulasan berhasil dikirim!")));
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mengirim ulasan: $e")));
    }
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Beri Ulasan", style: TextStyle(fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT INFO CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.productFoto.isNotEmpty
                        ? Image.memory(
                            base64Decode(widget.productFoto),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image),
                          ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // RATING SECTION
            const Center(
              child: Text(
                "Bagaimana kualitas produk ini?",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    Icons.star_rounded,
                    color: i < rating ? Colors.orange : Colors.grey.shade300,
                  ),
                  onPressed: () => setState(() => rating = i + 1),
                );
              }),
            ),

            const SizedBox(height: 30),

            // REVIEW TEXTFIELD
            const Text(
              "Tulis ulasan Anda",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Bagikan pengalaman Anda menggunakan produk ini...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),

            const Spacer(),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D580B), // Forest Green
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Kirim Ulasan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
