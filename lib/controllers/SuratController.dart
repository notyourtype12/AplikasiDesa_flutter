import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';

Future<Map<String, dynamic>?> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final nik = prefs.getString('nik');

  if (nik == null) {
    print('NIK tidak ditemukan di SharedPreferences');
    return null;
  }

  try {
    final response = await http.get(
      Uri.parse('$baseURL/getdata?nik=$nik'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final data = json.decode(responseBody)['data'];
      return data;
    } else {
      print('Gagal ambil data user: Status code ${response.statusCode}');
      print('Response body saat error: ${response.body}');
    }
  } catch (e, stacktrace) {
    print('Terjadi kesalahan: $e');
    print('Stacktrace: $stacktrace');
  }

  return null;
}

