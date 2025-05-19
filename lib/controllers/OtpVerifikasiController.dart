import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/globals.dart';
import '../auth/ResetPassword.dart';
import '../auth/OtpVerifikasi.dart'; // ⬅ import helper

class OtpVerifikasiController extends ChangeNotifier {
  String _email = '';
  String get email => _email;

  String _otpCode = '';
  String get otpCode => _otpCode;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setOtpCode(String value) {
    _otpCode = value;
    notifyListeners();
  }

 Future<void> verifyOtp(
    BuildContext context, {
    required String email,
    required void Function({
      required String message,
      required Color backgroundColor,
      IconData? icon,
    })
    showSnackbar,
  }) async {
    if (_otpCode.isEmpty || _otpCode.length != 6) {
      showSnackbar(
        message: "Kode OTP harus 6 digit",
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseURL/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'otp': _otpCode, 'email': email}),
      );

      final data = json.decode(response.body);

      // ✅ Cek sukses
      if (response.statusCode == 200 && data['status'] == 200) {
        showSnackbar(
          message: data['message'] ?? "OTP valid",
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => ResetPasswordPage(email: email, otp: _otpCode),
              ),
            );
          }
        });
      } else {
        showSnackbar(
          message: data['message'] ?? "OTP tidak valid",
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }

    } catch (e) {
      showSnackbar(
        message: "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        icon: Icons.error_outline,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
