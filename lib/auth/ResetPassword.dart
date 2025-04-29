import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:digitalv/controllers/ResetPasswordController.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = ResetPasswordController();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => controller,
      child: Consumer<ResetPasswordController>(
        builder: (context, controller, _) => Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: SvgPicture.asset(
                  'assets/images/bk_password.svg',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Buka Akun E-mail Anda Untuk Melihat Kode OTP',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),

                        // Password Baru
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            obscureText: !isPasswordVisible,
                            onChanged: controller.setNewPassword,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Password Baru',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Konfirmasi Password
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            obscureText: !isConfirmPasswordVisible,
                            onChanged: controller.setConfirmPassword,
                            decoration: InputDecoration(
                              hintText: 'Konfirmasi Password Baru',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tombol Reset
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => controller.resetPassword(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue[200],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
