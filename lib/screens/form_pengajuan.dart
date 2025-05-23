import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/LoginRegis.dart';
import '../config/globals.dart';
import '../controllers/SuratController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digitalv/widgets/snackbarcustom.dart';
import 'package:digitalv/screens/status.dart';


class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController golDarahController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController kewarganegaraanController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  // final TextEditingController statusNikahController = TextEditingController(text: 'Belum Kawin');
  final TextEditingController statusKeluargaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
  final TextEditingController keperluanController = TextEditingController();

  File? _foto1; // foto kk

  @override
  void initState() {
    super.initState();
    _loadUserData(); // ← ini penting!
  }

  Future<void> _loadUserData() async {
    final data = await fetchUserData();
    if (data != null) {
      setState(() {
        namaController.text = data['nama'] ?? '';
        nikController.text = data['nik'] ?? '';
        tempatLahirController.text = data['tempatLahir'] ?? '';
        tanggalLahirController.text = data['tanggalLahir'] ?? '';
        golDarahController.text = data['golDarah'] ?? '';
        jkController.text = data['jk'] ?? '';
        kewarganegaraanController.text = data['kewarganegaraan'] ?? '';
        agamaController.text = data['agama'] ?? '';
        statusKeluargaController.text = data['statusKeluarga'] ?? '';
        pekerjaanController.text = data['pekerjaan'] ?? '';
        pendidikanController.text = data['pendidikan'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FORM PENGAJUAN',
         style: GoogleFonts.poppins(
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
            

        padding: const EdgeInsets.all(16),
          
        child: Column(
          children: [
            buildInputField('Nama lengkap', namaController, readOnly: true),
            buildInputField('NIK', nikController, readOnly: true),
            buildInputField('Tempat Lahir', tempatLahirController, readOnly: true),
            buildInputField('Tanggal Lahir', tanggalLahirController, readOnly: true),
            buildInputField('Golongan Darah', golDarahController, readOnly: true),
            buildInputField('Jenis Kelamin', jkController, readOnly: true),
            buildInputField('Kewarganegaraan', kewarganegaraanController, readOnly: true),
            buildInputField('Agama', agamaController, readOnly: true),
            // buildInputField('Status Perkawinan', statusNikahController, readOnly: true),
            buildInputField('Status Keluarga', statusKeluargaController, readOnly: true),
            buildInputField('Pekerjaan', pekerjaanController, readOnly: true),
            buildInputField('Pendidikan', pendidikanController, readOnly: true),
            buildInputField('Keperluan', keperluanController),
            const SizedBox(height: 16),
         buildUploadField('Foto KTP', _foto1, (file) {
              setState(() => _foto1 = file);
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
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
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final Color borderColor = readOnly ? const Color.fromARGB(255, 13, 103, 221) : const Color(0xFF0057A6);
    final Color textColor = readOnly ? Colors.grey.shade700 : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.black, fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: borderColor,
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
            borderSide: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

Widget buildUploadField(
    String label,
    File? imageFile,
    Function(File) onImagePicked,
  ) {
    return InkWell(
      onTap: () async {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null) {
          onImagePicked(File(pickedFile.path));
        }
      },
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
              imageFile == null
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
                        label,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0057A6),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                  : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      imageFile,
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
