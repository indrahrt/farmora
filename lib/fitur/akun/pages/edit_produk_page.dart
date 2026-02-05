import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/product_controller.dart';

class EditProdukPage extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;

  const EditProdukPage({
    super.key,
    required this.docId,
    required this.initialData,
  });

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = ProductController();

  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController priceController;
  late TextEditingController descController;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _stockFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  String? selectedType;
  String? base64Image;
  bool loading = false;

  final Color primaryColor = const Color(0xFF1D580B);
  final Color scaffoldBg = const Color(0xFFF8FAF8);
  final List<String> categories = ['Sayur', 'Buah'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData['name']);
    stockController = TextEditingController(
      text: widget.initialData['stock'].toString(),
    );
    priceController = TextEditingController(
      text: widget.initialData['price'].toString(),
    );
    descController = TextEditingController(
      text: widget.initialData['description'],
    );
    selectedType = widget.initialData['type'];
    base64Image = widget.initialData['imageBase64'];

    _nameFocus.addListener(() => setState(() {}));
    _stockFocus.addListener(() => setState(() {}));
    _priceFocus.addListener(() => setState(() {}));
    _descFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _stockFocus.dispose();
    _priceFocus.dispose();
    _descFocus.dispose();
    nameController.dispose();
    stockController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  InputDecoration _inputStyle(String label, IconData icon, bool isFocused) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: isFocused ? primaryColor : Colors.grey),
      filled: true,
      fillColor: Colors.white,
      labelStyle: TextStyle(color: isFocused ? primaryColor : Colors.grey),
      floatingLabelStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  Future<void> update() async {
    if (!_formKey.currentState!.validate()) return;
    if (base64Image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Mohon pilih foto produk")));
      return;
    }

    setState(() => loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .update({
            'name': nameController.text.trim(),
            'type': selectedType,
            'stock': int.parse(stockController.text),
            'price': int.parse(priceController.text),
            'description': descController.text.trim(),
            'imageBase64': base64Image,
          });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil diperbarui")));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> deleteProduct() async {
    setState(() => loading = true);
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .delete();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk dihapus")));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showDeleteConfirmation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Hapus Produk?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Produk '${nameController.text}' akan dihapus permanen.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteProduct();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      "Ya, Hapus",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text(
          "Edit Produk",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: scaffoldBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FOTO PRODUK
              GestureDetector(
                onTap: () async {
                  final img = await controller.pickImageBase64();
                  if (img != null) setState(() => base64Image = img);
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    // PERBAIKAN: withOpacity diganti withValues
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.1),
                    ),
                    image: base64Image != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(base64Image!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: base64Image == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 30),

              TextFormField(
                controller: nameController,
                focusNode: _nameFocus,
                decoration: _inputStyle(
                  "Nama Produk",
                  Icons.shopping_bag,
                  _nameFocus.hasFocus,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedType,
                dropdownColor: Colors.white,
                items: categories
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedType = v),
                decoration: _inputStyle("Kategori", Icons.category, false),
                validator: (v) => v == null ? "Pilih kategori" : null,
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: stockController,
                      focusNode: _stockFocus,
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle(
                        "Stok",
                        Icons.inventory,
                        _stockFocus.hasFocus,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? "Pilih Jenis Produk"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      focusNode: _priceFocus,
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle(
                        "Harga",
                        Icons.payments,
                        _priceFocus.hasFocus,
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? "Wajib isi" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: descController,
                focusNode: _descFocus,
                maxLines: 3,
                decoration: _inputStyle(
                  "Deskripsi",
                  Icons.notes,
                  _descFocus.hasFocus,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? "Deskripsi wajib diisi" : null,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : update,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Simpan Perubahan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: TextButton.icon(
                  onPressed: loading ? null : _showDeleteConfirmation,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    "Hapus Produk",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      // PERBAIKAN: withOpacity diganti withValues
                      side: BorderSide(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
