import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../controller/product_controller.dart';

class MenjualPage extends StatefulWidget {
  const MenjualPage({super.key});

  @override
  State<MenjualPage> createState() => _MenjualPageState();
}

class _MenjualPageState extends State<MenjualPage> {
  final _formKey = GlobalKey<FormState>();
  final controller = ProductController();

  final nameController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  String? selectedType;
  String? base64Image;
  bool loading = false;

  final Color primaryColor = const Color(0xFF1D580B);
  final Color accentColor = const Color(0xFFF1F8E9);

  final productTypes = ['Sayur', 'Buah'];

  Future<void> pickImage() async {
    final img = await controller.pickImageBase64();
    if (img != null) {
      setState(() => base64Image = img);
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    if (base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gambar produk wajib diisi'),
          backgroundColor: Colors.redAccent[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final product = ProductModel(
        name: nameController.text.trim(),
        type: selectedType!,
        stock: int.parse(stockController.text),
        price: int.parse(priceController.text),
        description: descController.text.trim(),
        imageBase64: base64Image!,
        ownerId: controller.currentUser.uid,
        createdAt: Timestamp.now(),
      );

      await controller.saveProduct(product);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan'),
          backgroundColor: Color.fromARGB(255, 7, 7, 7),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('Save product error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan produk')));
    } finally {
      setState(() => loading = false);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon, {Color? fillColor}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: fillColor ?? Colors.grey[50],
      labelStyle: const TextStyle(color: Colors.grey),
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
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Jual Produk',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 2,
                    ),
                    image: base64Image != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(base64Image!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: base64Image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 45,
                              color: primaryColor,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tambah Foto Produk',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                "Detail Informasi",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: nameController,
                decoration: _inputStyle(
                  'Nama Produk',
                  Icons.shopping_bag_outlined,
                ),
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              /// 🔧 FIX DI SINI (value ➜ initialValue)
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                dropdownColor: Colors.white,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: productTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedType = v;
                  });
                },
                decoration: _inputStyle(
                  'Jenis Produk',
                  Icons.category_outlined,
                  fillColor: Colors.white,
                ),
                validator: (v) => v == null ? 'Pilih jenis produk' : null,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: stockController,
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle(
                        'Stok',
                        Icons.inventory_2_outlined,
                      ),
                      validator: (v) => v!.isEmpty ? 'Wajib isi' : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle('Harga', Icons.payments_outlined),
                      validator: (v) => v!.isEmpty ? 'Wajib isi' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descController,
                maxLines: 4,
                decoration: _inputStyle(
                  'Deskripsi Produk',
                  Icons.description_outlined,
                ),
                validator: (v) => v!.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Simpan Produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
