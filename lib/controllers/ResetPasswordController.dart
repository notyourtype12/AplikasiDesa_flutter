import 'package:flutter/material.dart';
import 'package:digitalv/auth/LoginRegis.dart';

class ResetPasswordController extends ChangeNotifier {
  String newPassword = '';
  String confirmPassword = '';

  void setNewPassword(String value) {
    newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  void resetPassword(BuildContext context) {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak boleh kosong")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak cocok")),
      );
      return;
    }

    // TODO: Panggil API / proses update password di sini
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil direset")),
    );

    // Arahkan ke halaman login setelah delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Loginregis()),
        (route) => false,
      );
    });
  }
}
