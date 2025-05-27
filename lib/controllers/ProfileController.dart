import 'dart:io';
import 'dart:convert';
import 'package:digitalv/auth/LoginRegis.dart';
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
      final jsonResponse = json.decode(response.body);
      final data = jsonResponse['data'];

      await prefs.setString('no_kk', data['no_kk'] ?? '');
      await prefs.setString('nama_lengkap', data['nama_lengkap'] ?? '');
      await prefs.setString('no_hp', data['no_hp'] ?? '');
      await prefs.setString('email', data['email'] ?? '');
      await prefs.setString('foto_profil', data['foto_profil'] ?? '');
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
  final prefs = await SharedPreferences.getInstance();
  final nik = prefs.getString('nik') ?? '';

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseURL/update-foto'),
  );
  request.fields['nik'] = nik;

  // Pastikan key sesuai controller Laravel: 'foto_profil'
  request.files.add(
    await http.MultipartFile.fromPath('foto_profil', imageFile.path),
  );

  // Tambahkan header ini agar Laravel balikan JSON meskipun error
  request.headers['Accept'] = 'application/json';

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      showCustomSnackbar(
        context: context,
        message: 'Foto profil berhasil diperbarui',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );
    } else {
      try {
        var data = json.decode(responseBody);
        String errorMessage = data['message'] ?? 'Gagal upload foto';

        // Kalau ada validation errors, gabungkan jadi satu string
        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values
              .map((e) => (e is List) ? e.join(', ') : e.toString())
              .join('\n');
        }

        showCustomSnackbar(
          context: context,
          message: errorMessage,
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      } catch (e) {
        // Kalau gagal decode JSON (mungkin HTML), tampilkan pesan error generik saja
        showCustomSnackbar(
          context: context,
          message: 'Gagal upload foto: Server mengembalikan data tidak valid',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    }
  } catch (e) {
    // Error network atau lainnya
    showCustomSnackbar(
      context: context,
      message: 'Error saat upload foto: ${e.toString()}',
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }
}

Future<bool> updateEmailNoHp(
  BuildContext context, {
  required String email,
  required String noHp,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final nik = prefs.getString('nik') ?? '';
  final url = Uri.parse('$baseURL/update-profil');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'nik': nik, 'email': email, 'no_hp': noHp}),
    );

    final responseBody = response.body;

    if (response.statusCode == 200) {
      var data = jsonDecode(responseBody);

      await prefs.setString('email', email);
      await prefs.setString('no_hp', noHp);

      showCustomSnackbar(
        context: context,
        message: data['message'] ?? 'Email dan No HP berhasil diperbarui',
        backgroundColor: Colors.green,
        icon: Icons.check_circle,
      );

      return true;
    } else {
      try {
        var data = jsonDecode(responseBody);
        String errorMessage = data['message'] ?? 'Gagal memperbarui data';

        if (data['errors'] != null && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage = errors.values
              .map((e) => (e is List) ? e.join(', ') : e.toString())
              .join('\n');
        }

        showCustomSnackbar(
          context: context,
          message: errorMessage,
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      } catch (e) {
        showCustomSnackbar(
          context: context,
          message:
              'Gagal memperbarui data: Server mengembalikan data tidak valid',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
      return false;
    }
  } catch (e) {
    showCustomSnackbar(
      context: context,
      message: 'Error saat memperbarui data: ${e.toString()}',
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
    return false;
  }
}


Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  // Cek jika ada token tersimpan
  if (token != null) {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🧾 Logout response: ${response.statusCode} ${response.body}');
      print('🔐 Token yang dikirim saat logout: $token');

      if (response.statusCode == 200) {
        showCustomSnackbar(
          context: context,
          message: 'Berhasil logout.',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      } else {
        showCustomSnackbar(
          context: context,
          message: 'Logout gagal di server.',
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
      }
    } catch (e) {
      print('❗ Error saat logout ke server: $e');
      showCustomSnackbar(
        context: context,
        message: 'Gagal menghubungi server.',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  } else {
    print('⚠️ Tidak ada token yang tersimpan.');
    showCustomSnackbar(
      context: context,
      message: 'Tidak ditemukan token untuk logout.',
      backgroundColor: Colors.orange,
      icon: Icons.info,
    );
  }

  // Hapus data lokal
  await prefs.remove('token');
  await prefs.remove('nama');
  await prefs.remove('nik');

  if (!context.mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Loginregis()),
    (route) => false,
  );
}
