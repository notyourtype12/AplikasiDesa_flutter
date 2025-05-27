import 'package:digitalv/screens/home.dart';
import 'package:digitalv/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import '../config/globals.dart';
import '../widgets/snackbarcustom.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class Pengaduan extends StatefulWidget {
  const Pengaduan({super.key});

  @override
  State<Pengaduan> createState() => _PengaduanState();
}

class _PengaduanState extends State<Pengaduan> {
  final TextEditingController ulasanController = TextEditingController();
  bool isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _selectedKategori;
  final List<String> _kategoriList = [
    'Fasilitas Umum',
    'Kebersihan',
    'Keamanan',
    'Lainnya',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik');

    if (nik == null) {
      showCustomSnackbar(
        context: context,
        message: 'NIK tidak ditemukan. Silakan login ulang.',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
      setState(() => isLoading = false);
      return;
    }

    final uri = Uri.parse('$baseURL/pengaduan');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json';


    request.fields['nik'] = nik;
    request.fields['ulasan'] = ulasanController.text;
    request.fields['kategori'] = _selectedKategori ?? '';

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'foto1',
          _imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }
    try {
      final response = await request.send();
      final res = await http.Response.fromStream(response);

      print('Response status code: ${res.statusCode}');
      print(
        'Response body: ${res.body}',
      ); // Penting untuk lihat pesan error server

      if (res.statusCode == 201) {
        showCustomSnackbar(
          context: context,
          message: 'Pengaduan berhasil dikirim!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
        );
      } else {
        showCustomSnackbar(
          context: context,
          message: 'Gagal kirim pengaduan: ${res.statusCode}',
          backgroundColor: Colors.red,
          icon: Icons.error,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        context: context,
        message: 'Terjadi kesalahan saat mengirim: $e',
        backgroundColor: Colors.red,
        icon: Icons.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FORM PENGADUAN',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0057A6),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.25),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // supaya scrollable jika layar kecil / keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildInputField('Ulasan', ulasanController),
              const SizedBox(height: 16),
              buildKategoriField(),
              const SizedBox(height: 16),
              buildUploadField('Upload foto pendukung'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null // disable tombol saat loading supaya gak double submit
                          : () {
                            if (_selectedKategori == null) {
                              showCustomSnackbar(
                                context: context,
                                message: 'Kategori belum dipilih',
                                backgroundColor: Colors.red,
                                icon: Icons.error,
                              );
                              return;
                            }

                            if (ulasanController.text.isEmpty) {
                              showCustomSnackbar(
                                context: context,
                                message: 'Ulasan tidak boleh kosong',
                                backgroundColor: Colors.red,
                                icon: Icons.error,
                              );
                              return;
                            }
                            // Ambil nik dari SharedPreferences
                            SharedPreferences.getInstance().then((prefs) {
                              final nik = prefs.getString('nik');
                              print('NIK: $nik');
                              print('Kategori: $_selectedKategori');
                              print('Ulasan: ${ulasanController.text}');
                              if (_imageFile != null) {
                                print('Gambar path: ${_imageFile!.path}');
                              } else {
                                print('Tidak ada gambar yang diupload');
                              }

                              _submitForm();
                            });
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0057A6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    height: 20,
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Kirim',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
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

  Widget buildInputField(String label, TextEditingController controller) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: controller, // <-- ini wajib agar text bisa terbaca
        maxLines: 5,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: const Color(0xFF0057A6),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0057A6), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0057A6), width: 2),
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 13),
      ),
    );
  }

  Widget buildKategoriField() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Kategori',
        labelStyle: GoogleFonts.poppins(
          color: Color(0xFF0057A6),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0057A6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0057A6), width: 2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedKategori,
          isExpanded: true,
          hint: const Text("Pilih kategori"),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF0057A6),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          items:
              _kategoriList.map((kategori) {
                IconData icon;
                switch (kategori) {
                  case 'Fasilitas Umum':
                    icon = Icons.home_repair_service;
                    break;
                  case 'Kebersihan':
                    icon = Icons.cleaning_services;
                    break;
                  case 'Keamanan':
                    icon = Icons.security;
                    break;
                  default:
                    icon = Icons.help_outline;
                }
                return DropdownMenuItem(
                  value: kategori,
                  child: Row(
                    children: [
                      Icon(icon, color: const Color(0xFF0057A6), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        kategori,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedKategori = value;
            });
          },
        ),
      ),
    );
  }

  Widget buildUploadField(String title) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 146,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF0057A6), width: 1.5),
        ),
        child: Center(
          child:
              _imageFile == null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/upload.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: Color(0xFF0057A6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
        ),
      ),
    );
  }
}
