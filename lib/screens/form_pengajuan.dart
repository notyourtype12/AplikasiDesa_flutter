import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  File? _imageFile; // Variable untuk menyimpan gambar yang dipilih

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
        title: const Text(
          'FORM PENGAJUAN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0057A6),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.25),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildInputField('Nama lengkap'),
              const SizedBox(height: 16),
              buildInputField('NIK'),
              const SizedBox(height: 16),
              buildInputField('Tempat & Tanggal Lahir'),
              const SizedBox(height: 16),
              buildInputField('Golongan Darah'),
              const SizedBox(height: 16),
              buildInputField('Jenis Kelamin'),
              const SizedBox(height: 16),
              buildInputField('Kewarganegaraan'),
              const SizedBox(height: 16),
              buildInputField('Agama'),
              const SizedBox(height: 16),
              buildInputField('Status Perkawinan'),
              const SizedBox(height: 16),
              buildInputField('Status Keluarga'),
              const SizedBox(height: 16),
              buildInputField('Pekerjaan'),
              const SizedBox(height: 16),
              buildInputField('Pendidikan'),
              const SizedBox(height: 16),
              buildInputField('Keperluan'),
              const SizedBox(height: 16),
              buildUploadField('Upload Foto KTP'),
              const SizedBox(height: 26),
              SizedBox(
                width: 125,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
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
        fillColor: const Color(0xFFEAF4FD),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildUploadField(String title) {
    return InkWell(
      onTap: _pickImage, //fungsi _pickImage pas diklik
      child: Container(
        width: double.infinity,
        height: 146,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FD),
          borderRadius: BorderRadius.circular(10),
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
              : Image.file(_imageFile!, fit: BoxFit.cover), //menampilkan gambar stlh dipilih
        ),
      ),
    );
  }
}
