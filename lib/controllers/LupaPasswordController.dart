import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/globals.dart';
import '../auth/OtpVerifikasi.dart';

class LupaPasswordController extends ChangeNotifier {
  String _email = '';
  bool _isLoading = false;

  String get email => _email;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<void> sendOtp(
    BuildContext context, {
    required void Function({
      required String message,
      required Color backgroundColor,
      IconData? icon,
    })
    showSnackbar,
  }) async {
    if (_email.isEmpty || !_email.contains('@')) {
      showSnackbar(
        message: 'Masukkan email yang valid',
        backgroundColor: Colors.red,
        icon: Icons.warning,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseURL/forgot-password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'email': _email}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 200) {
        showSnackbar(
          message: data['message'],
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(email: _email),
            ),
          );
        });
      } else {
        showSnackbar(
          message: data['message'] ?? 'Gagal mengirim OTP',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      showSnackbar(
        message: 'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
