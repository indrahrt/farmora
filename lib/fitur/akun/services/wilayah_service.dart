import 'dart:convert';
import 'package:http/http.dart' as http;

class WilayahService {
  static const baseUrl = 'https://emsifa.github.io/api-wilayah-indonesia/api';

  static Future<List<dynamic>> getProvinsi() async {
    final res = await http.get(Uri.parse('$baseUrl/provinces.json'));
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getKabupaten(String provId) async {
    final res = await http.get(Uri.parse('$baseUrl/regencies/$provId.json'));
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getKecamatan(String kabId) async {
    final res = await http.get(Uri.parse('$baseUrl/districts/$kabId.json'));
    return jsonDecode(res.body);
  }

  static Future<List<dynamic>> getDesa(String kecId) async {
    final res = await http.get(Uri.parse('$baseUrl/villages/$kecId.json'));
    return jsonDecode(res.body);
  }
}
