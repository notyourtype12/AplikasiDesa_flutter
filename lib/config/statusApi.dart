import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/status_model.dart';
import 'globals.dart';

class ApiService {
  static Future<List<PengajuanModel>> fetchPengajuan(String status) async {
    final response = await http.get(Uri.parse('$baseURL/statusdiajukan'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((item) => PengajuanModel.fromJson(item))
          .where((item) => item.status == status)
          .toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}
