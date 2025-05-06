import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/status_model.dart';
import 'globals.dart';

class ApiService {
  static Future<List<PengajuanModel>> fetchPengajuan() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      throw Exception('NIK tidak ditemukan di SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('$baseURL/statusdiajukan?nik=$nik'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => PengajuanModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }
}
