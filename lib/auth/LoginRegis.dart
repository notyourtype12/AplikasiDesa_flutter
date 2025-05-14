import 'package:digitalv/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import '../shared/shared.dart';
import 'dart:math';
import '../config/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginregis extends StatefulWidget {
  const Loginregis({super.key});

  @override
  _LoginregisState createState() => _LoginregisState();
}

class _LoginregisState extends State<Loginregis> {
  bool isVisible = false;
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>(); // Tambahkan ini
  final _nikController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final nikLoginController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Backend registrasi
  Future<void> _register() async {
    final String nik = _nikController.text.trim();
    final String password = _passwordController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();

    if (nik.isEmpty || password.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    try {
      final response = await http.post(
        // Uri.parse('http://127.0.0.1:8000/api/register'),
        Uri.parse('$baseURL/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nik': nik,
          'password': password,
          'email': email,
          'no_hp': phone,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } 
    on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet')),
      );
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi timeout, coba lagi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  // Backend login
  Future<void> login(BuildContext context) async {
    final String nikLogin = nikLoginController.text.trim();
    final String passwordLogin = loginPasswordController.text.trim();

    if (nikLogin.isEmpty || passwordLogin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIK dan Password harus diisi')),
      );
      return;
    }

    try {
      final response = await http.post(
        // Uri.parse('http://127.0.0.1:8000/api/login'), 
        Uri.parse('$baseURL/login'),
      

        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nik': nikLogin, 'password': passwordLogin}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login berhasil')));

      String namaPengguna = responseData['master_akun']['nama'];
        String nikPengguna = responseData['master_akun']['nik'];

        await _saveUserData(namaPengguna, nikPengguna);
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()), 
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('NIK atau Password Salah')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${responseData['message']}')),
        );
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada koneksi internet')),
      );
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi timeout, coba lagi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  Future<void> _saveUserData(String nama, String nik) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', nama);
     await prefs.setString('nik', nik);
  }

      @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar background yang mengisi seluruh layar
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/FIRST PAGE.svg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Konten yang akan ditampilkan di atas gambar background
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
           
                  Image.asset('assets/images/boy2.png',
                  width: MediaQuery.of(context).size.width - 40),

                  // const Text(
                  //   "Selamat Datang",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height: 15),
                  // const Text(
                  //   "Kami Siap Mempermudah Anda",
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 20,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // const SizedBox(height:  1),
                const SizedBox(height: 20), // Jarak antara gambar dan teks
                
                SizedBox(
                width: 215, // samain dengan tombol aktivasi
                child: const Text(
                  "Pertama kali menggunakan aplikasi?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 5),

            

                  // Tombol aktivasi
                  SizedBox(
                    height: 39,
                    // width: MediaQuery.of(context).size.width - 40,
                    width: 215,

                    child: ElevatedButton(
                      onPressed: () {
                        showRegisterModal(context);
                      },
                      
                      child: const Text(
                        'Aktivasi Akun',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color.fromARGB(255, 212, 209, 181),
                        backgroundColor: primaryColor,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // text 
                  
                 SizedBox(
                width: 215, //agar posisi sama dengan login (mulai dari kiri sehingga sejajar)
                child: const Text(
                  "Sudah aktivasi akun?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 5),

                  // Tombol Login
                  SizedBox(
                    height: 39,
                      width: 215,
                    // width: 215,

                    child: ElevatedButton(
                      onPressed: () {
                        showLoginModal(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0057A6),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: const Color.fromARGB(255, 78, 163, 232),
                        backgroundColor: whiteColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: primaryColor, 
                            width: 3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // Modal aktivasi
void showRegisterModal(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              controller: scrollController, // ini penting biar scroll jalan
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Text(
                      "Aktivasi akun",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),

                    // NIK
                    TextFormField(
                      controller: _nikController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'NIK',
                        hintText: 'Masukkan NIK Anda',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK tidak boleh kosong';
                        }
                        return null;
                      },
                    ),


                    
                    const SizedBox(height: 20),

                                                // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !isVisible,
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  icon: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                labelText: 'Password',
                                hintText: 'Masukkan Password Anda',
                                border: const OutlineInputBorder(),
                              ),
                              style: TextStyle(fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),



                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'E-Mail',
                        hintText: 'Masukkan E-Mail Anda',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-Mail tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Nomor HP
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.phone),
                        labelText: 'Nomor HP',
                        hintText: 'Masukkan Nomor HP Anda',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 14),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor HP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Tombol Aktivasi
                  Container(
  margin: const EdgeInsets.only(left: 40),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start, 
    children: [
      SizedBox(
        height: 50,
        width: 440,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _register();
            }
          },
          child: const Text(
            'Aktivasi akun',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFF0057A6), width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  ),
)
,
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

   
  // Modal untuk Login
  void showLoginModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
  return DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.5, // tinggi awal 50% layar
    minChildSize: 0.4,     // tinggi minimum
    maxChildSize: 0.9,     // tinggi maksimum bisa ditarik
    builder: (context, scrollController) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: SingleChildScrollView(
          controller: scrollController, // penting biar scroll lancar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // NIK
              TextFormField(
                controller: nikLoginController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'NIK',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Password
              TextFormField(
                controller: loginPasswordController,
                obscureText: !isPasswordVisible,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Tombol Login
              Container(
                margin: const EdgeInsets.only(left: 40),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
},

    );
  }
}