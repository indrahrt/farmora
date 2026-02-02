class WilayahModel {
  final String id;
  final String nama;

  WilayahModel({required this.id, required this.nama});

  factory WilayahModel.fromJson(Map<String, dynamic> json) {
    return WilayahModel(id: json['id'], nama: json['name']);
  }
}
