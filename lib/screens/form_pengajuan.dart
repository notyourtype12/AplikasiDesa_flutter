import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormPengajuan extends StatefulWidget {
  const FormPengajuan({super.key});

  @override
  State<FormPengajuan> createState() => _FormPengajuanState();
}

class _FormPengajuanState extends State<FormPengajuan> {
  final TextEditingController namaController = TextEditingController(text: 'Mochammad Adji');
  final TextEditingController nikController = TextEditingController(text: '3201234567890001');
  final TextEditingController tempatLahirController = TextEditingController(text: 'Lumajang');
  final TextEditingController tanggalLahirController = TextEditingController(text: '07-11-2004');
  final TextEditingController golDarahController = TextEditingController(text: 'O');
  final TextEditingController jkController = TextEditingController(text: 'Laki-laki');
  final TextEditingController kewarganegaraanController = TextEditingController(text: 'Indonesia');
  final TextEditingController agamaController = TextEditingController(text: 'Islam');
  final TextEditingController statusNikahController = TextEditingController(text: 'Belum Kawin');
  final TextEditingController statusKeluargaController = TextEditingController(text: 'Anak');
  final TextEditingController pekerjaanController = TextEditingController(text: 'Mahasiswa');
  final TextEditingController pendidikanController = TextEditingController(text: 'D4/S1');
  final TextEditingController keperluanController = TextEditingController();

  File? _imageFile;

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
            buildInputField('Status Perkawinan', statusNikahController, readOnly: true),
            buildInputField('Status Keluarga', statusKeluargaController, readOnly: true),
            buildInputField('Pekerjaan', pekerjaanController, readOnly: true),
            buildInputField('Pendidikan', pendidikanController, readOnly: true),
            buildInputField('Keperluan', keperluanController),
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
        style: TextStyle(color: textColor),
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
