import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';
import '../widgets/snackbarcustom.dart'; 
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

Future<void> getProfilFromApi(BuildContext context) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'NIK tidak ditemukan di penyimpanan lokal',
        backgroundColor: Colors.orange,
        icon: Icons.error,
      );
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
      showCustomSnackbar(
        context: context,
        message: message,
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  } catch (e) {
    showCustomSnackbar(
      context: context,
      message: 'Gagal mengambil data profil: $e',
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }
}

Future<void> uploadFotoProfil(BuildContext context, File imageFile) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'NIK tidak ditemukan.',
        backgroundColor: Colors.orange,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    final url = Uri.parse('$baseURL/update-foto');
    final request = http.MultipartRequest('POST', url)..fields['nik'] = nik;

    final mimeType = lookupMimeType(imageFile.path)?.split('/');
    if (mimeType == null || mimeType.length != 2) {
      throw 'Tipe file tidak dikenali';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'foto',
        imageFile.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ),
    );

    request.headers.addAll(headers);

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = json.decode(responseData);
      final fotoUrl = jsonData['foto_url'] ?? '';

      await prefs.setString('foto_url', fotoUrl);

      showCustomSnackbar(
        context: context,
        message: 'Foto profil berhasil diunggah.',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
    } else {
      final errorData = json.decode(responseData);
      showCustomSnackbar(
        context: context,
        message: errorData['message'] ?? 'Gagal mengunggah foto.',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  } catch (e) {
    showCustomSnackbar(
      context: context,
      message: 'Error saat upload foto: $e',
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }
}
