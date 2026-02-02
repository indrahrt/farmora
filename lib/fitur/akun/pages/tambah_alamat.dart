import 'package:flutter/material.dart';
import '../controller/alamat_controller.dart';
import '../models/alamat_models.dart';
import '../services/wilayah_service.dart';

class TambahAlamatPage extends StatefulWidget {
  final AlamatModel? alamat;

  const TambahAlamatPage({super.key, this.alamat});

  @override
  State<TambahAlamatPage> createState() => _TambahAlamatPageState();
}

class _TambahAlamatPageState extends State<TambahAlamatPage> {
  final controller = AlamatController();

  final namaController = TextEditingController();
  final alamatLengkapController = TextEditingController();

  List<dynamic> provinsiList = [];
  List<dynamic> kabupatenList = [];
  List<dynamic> kecamatanList = [];
  List<dynamic> desaList = [];

  String? provinsiId, kabupatenId, kecamatanId, desaId;

  bool isLoading = false;
  bool get isEdit => widget.alamat != null;

  final Color primaryGreen = const Color.fromARGB(255, 29, 88, 11);

  @override
  void initState() {
    super.initState();
    _loadProvinsi();

    if (isEdit) {
      namaController.text = widget.alamat!.nama;
      alamatLengkapController.text = widget.alamat!.alamatLengkap;
    }
  }

  Future<void> _loadProvinsi() async {
    final data = await WilayahService.getProvinsi();
    setState(() => provinsiList = data);

    if (isEdit) {
      try {
        final prov = data.firstWhere(
          (e) => e['name'] == widget.alamat!.provinsi,
        );
        provinsiId = prov['id'];
        await _loadKabupaten(provinsiId!);
      } catch (e) {
        debugPrint("Provinsi tidak ditemukan");
      }
    }
  }

  Future<void> _loadKabupaten(String provId) async {
    final data = await WilayahService.getKabupaten(provId);
    setState(() => kabupatenList = data);

    if (isEdit) {
      try {
        final kab = data.firstWhere(
          (e) => e['name'] == widget.alamat!.kabupaten,
        );
        kabupatenId = kab['id'];
        await _loadKecamatan(kabupatenId!);
      } catch (e) {
        debugPrint("Kabupaten tidak ditemukan");
      }
    }
  }

  Future<void> _loadKecamatan(String kabId) async {
    final data = await WilayahService.getKecamatan(kabId);
    setState(() => kecamatanList = data);

    if (isEdit) {
      try {
        final kec = data.firstWhere(
          (e) => e['name'] == widget.alamat!.kecamatan,
        );
        kecamatanId = kec['id'];
        await _loadDesa(kecamatanId!);
      } catch (e) {
        debugPrint("Kecamatan tidak ditemukan");
      }
    }
  }

  Future<void> _loadDesa(String kecId) async {
    final data = await WilayahService.getDesa(kecId);
    setState(() => desaList = data);

    if (isEdit) {
      try {
        final des = data.firstWhere((e) => e['name'] == widget.alamat!.desa);
        desaId = des['id'];
      } catch (e) {
        debugPrint("Desa tidak ditemukan");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Alamat' : 'Tambah Alamat',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _konfirmasiHapus,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelSection("Informasi Penerima"),
                  _input(namaController, 'Nama Penerima', Icons.person_outline),
                  const SizedBox(height: 12),
                  _labelSection("Wilayah"),
                  _dropdown('Pilih Provinsi', provinsiList, provinsiId, (
                    v,
                  ) async {
                    setState(() {
                      provinsiId = v;
                      kabupatenId = kecamatanId = desaId = null;
                      kabupatenList = kecamatanList = desaList = [];
                    });
                    await _loadKabupaten(v!);
                  }),
                  _dropdown('Pilih Kabupaten', kabupatenList, kabupatenId, (
                    v,
                  ) async {
                    setState(() {
                      kabupatenId = v;
                      kecamatanId = desaId = null;
                      kecamatanList = desaList = [];
                    });
                    await _loadKecamatan(v!);
                  }),
                  _dropdown('Pilih Kecamatan', kecamatanList, kecamatanId, (
                    v,
                  ) async {
                    setState(() {
                      kecamatanId = v;
                      desaId = null;
                      desaList = [];
                    });
                    await _loadDesa(v!);
                  }),
                  _dropdown(
                    'Pilih Desa',
                    desaList,
                    desaId,
                    (v) => setState(() => desaId = v),
                  ),
                  const SizedBox(height: 12),
                  _labelSection("Detail Alamat"),
                  _input(
                    alamatLengkapController,
                    'Alamat Lengkap (Jalan, No Rumah)',
                    Icons.map_outlined,
                    max: 3,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _simpan,
                      child: Text(
                        isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN ALAMAT',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _simpan() async {
    if (provinsiId == null ||
        kabupatenId == null ||
        kecamatanId == null ||
        desaId == null ||
        namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data terlebih dahulu')),
      );
      return;
    }

    setState(() => isLoading = true);

    final alamat = AlamatModel(
      id: widget.alamat?.id ?? '',
      nama: namaController.text,
      provinsi: _name(provinsiList, provinsiId),
      kabupaten: _name(kabupatenList, kabupatenId),
      kecamatan: _name(kecamatanList, kecamatanId),
      desa: _name(desaList, desaId),
      alamatLengkap: alamatLengkapController.text,
    );

    isEdit
        ? await controller.updateAlamat(alamat)
        : await controller.simpanAlamat(alamat);

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _konfirmasiHapus() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Alamat'),
        content: const Text('Yakin ingin menghapus alamat ini dari daftar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await controller.hapusAlamat(widget.alamat!.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Widget _labelSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryGreen,
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String label,
    IconData icon, {
    int max = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        maxLines: max,
        cursorColor: primaryGreen,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, size: 20, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryGreen, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List list,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        // PERUBAHAN DI SINI: Mengatur warna background daftar list dropdown
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryGreen, width: 2),
          ),
        ),
        items: list.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem(value: e['id'], child: Text(e['name']));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  String _name(List list, String? id) =>
      list.firstWhere((e) => e['id'] == id, orElse: () => {'name': ''})['name'];
}
