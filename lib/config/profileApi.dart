import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';

void errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text),
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<void> getProfilFromApi(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      errorSnackBar(context, 'NIK tidak ditemukan di penyimpanan lokal');
      return; 
    }

    final url = Uri.parse('$baseURL/getprofil?nik=$nik');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      await prefs.setString('no_kk', data['no_kk'] ?? '');
      await prefs.setString('nama_lengkap', data['nama_lengkap'] ?? '');
      await prefs.setString('no_hp', data['no_hp'] ?? '');
      await prefs.setString('email', data['email'] ?? '');
    } else {
      final message =
          json.decode(response.body)['error'] ?? 'Terjadi kesalahan';
      errorSnackBar(context, message);
    }
  } catch (e) {
    errorSnackBar(context, 'Gagal mengambil data profil: $e');
  }
}
