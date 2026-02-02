import 'package:flutter/material.dart';
import '../pages/edit_produk_page.dart';

class ProductActions extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> productData;
  final Color primaryColor;

  const ProductActions({
    super.key,
    required this.docId,
    required this.productData,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.more_horiz, size: 20, color: Colors.black87),
      ),
      onSelected: (value) {
        if (value == 'edit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EditProdukPage(docId: docId, initialData: productData),
            ),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_note_rounded, size: 22, color: Colors.blue),
              SizedBox(width: 10),
              Text('Edit / Hapus'),
            ],
          ),
        ),
      ],
    );
  }
}
