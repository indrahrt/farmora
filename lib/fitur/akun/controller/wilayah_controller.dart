import '../models/wilayah_models.dart';
import '../services/wilayah_service.dart';

class WilayahController {
  Future<List<WilayahModel>> getProvinsi() async {
    final data = await WilayahService.getProvinsi();
    return data.map((e) => WilayahModel.fromJson(e)).toList();
  }

  Future<List<WilayahModel>> getKabupaten(String provId) async {
    final data = await WilayahService.getKabupaten(provId);
    return data.map((e) => WilayahModel.fromJson(e)).toList();
  }

  Future<List<WilayahModel>> getKecamatan(String kabId) async {
    final data = await WilayahService.getKecamatan(kabId);
    return data.map((e) => WilayahModel.fromJson(e)).toList();
  }

  Future<List<WilayahModel>> getDesa(String kecId) async {
    final data = await WilayahService.getDesa(kecId);
    return data.map((e) => WilayahModel.fromJson(e)).toList();
  }
}
