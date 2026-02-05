import 'package:flutter/material.dart';

class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      /// ✅ APPBAR STYLE BARU
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,

        /// BUTTON BACK <
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        /// TITLE TENGAH
        title: const Text(
          "Artikel",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: const [
          ArtikelCard(
            title: "Cara Menanam Cabai yang Benar",
            desc: "Panduan lengkap menanam cabai agar hasil maksimal.",
            content:
                "Cabai membutuhkan tanah yang gembur dan sinar matahari cukup. "
                "Gunakan pupuk organik dan lakukan penyiraman rutin setiap pagi dan sore.",
          ),
          ArtikelCard(
            title: "Tips Pupuk Organik",
            desc: "Gunakan pupuk alami untuk hasil lebih sehat.",
            content:
                "Pupuk organik dapat dibuat dari kompos, kotoran hewan, atau limbah dapur. "
                "Gunakan secara rutin untuk meningkatkan kesuburan tanah.",
          ),
          ArtikelCard(
            title: "Mengatasi Hama Tanaman",
            desc: "Cara alami mengusir hama tanpa bahan kimia.",
            content:
                "Gunakan pestisida alami seperti campuran bawang putih dan air. "
                "Semprotkan pada daun secara berkala untuk mencegah hama.",
          ),
        ],
      ),
    );
  }
}

class ArtikelCard extends StatelessWidget {
  final String title;
  final String desc;
  final String content;

  const ArtikelCard({
    super.key,
    required this.title,
    required this.desc,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArtikelDetailPage(title: title, content: content),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class ArtikelDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const ArtikelDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// HEADER DETAIL STYLE SAMA
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(content, style: const TextStyle(fontSize: 16, height: 1.6)),
      ),
    );
  }
}
