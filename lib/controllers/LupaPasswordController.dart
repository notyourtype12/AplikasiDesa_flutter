import 'package:flutter/material.dart';
import 'package:digitalv/auth/OtpVerifikasi.dart';

class LupaPasswordController extends ChangeNotifier {
  String email = '';

  void setEmail(String value) {
    email = value;
    notifyListeners(); // Jika perlu memicu rebuild
  }

  void sendOtp(BuildContext context) {
    if (email.isNotEmpty && email.contains('@')) {
      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kode OTP dikirim ke $email"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi aman ke halaman OTP setelah sedikit delay
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OtpVerificationPage()),
        );
      });
    } else {
      // Tampilkan snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Masukkan email yang valid"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
