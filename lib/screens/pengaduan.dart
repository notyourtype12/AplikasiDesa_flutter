import 'package:digitalv/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class Pengaduan extends StatefulWidget {
  const Pengaduan({super.key});

  @override
  State<Pengaduan> createState() => _PengaduanState();
}

class _PengaduanState extends State<Pengaduan> {
  File? _imageFile; 

  final ImagePicker _picker = ImagePicker(); 

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
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
            color: Color(0xFF0057A6),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildInputField('Ulasan'),
            const SizedBox(height: 16),
            buildUploadField('Upload foto pendukung'),
            const SizedBox(height: 16),
            SizedBox(
              width: 125,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengaduan berhasil dikirim!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0057A6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Kirim',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
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
          borderSide: const BorderSide(
            color: Color(0xFF0057A6),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFF0057A6),
            width: 2,
          ),
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
          border: Border.all(
            color: const Color(0xFF0057A6),
            width: 1.5,
          ),
        ),
        child: Center(
          child: _imageFile == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/upload.png', width: 50, height: 50),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
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
