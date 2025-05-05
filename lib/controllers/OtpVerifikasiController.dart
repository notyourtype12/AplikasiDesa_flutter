import 'package:flutter/material.dart';
import 'package:digitalv/auth/ResetPassword.dart';

class OtpVerifikasiController extends ChangeNotifier {
  String otpCode = '';

  void setOtpCode(String value) {
    otpCode = value;
    notifyListeners(); // Jika UI perlu diupdate
  }

  void verifyOtp(BuildContext context) {
    if (otpCode == '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP berhasil diverifikasi"),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ResetPasswordPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kode OTP salah"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
