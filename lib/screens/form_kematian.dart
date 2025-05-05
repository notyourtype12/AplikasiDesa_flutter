import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class FormKematian extends StatefulWidget {
  const FormKematian({super.key});

  @override
  State<FormKematian> createState() => _FormKematianState();
}

class _FormKematianState extends State<FormKematian> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaalmController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController golDarahController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController kewarganegaraanController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  final TextEditingController statusNikahController = TextEditingController();
  final TextEditingController statusKeluargaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> submitPengajuan() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data dengan benar.')),
      );
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/pengajuan'); // Ganti IP sesuai server Anda
    var request = http.MultipartRequest('POST', uri);

    request.fields['nama_alm'] = namaalmController.text;
    request.fields['nama'] = namaController.text;
    request.fields['nik'] = nikController.text;
    request.fields['tempat_lahir'] = tempatLahirController.text;
    request.fields['tanggal_lahir'] = tanggalLahirController.text;
    request.fields['gol_darah'] = golDarahController.text;
    request.fields['jk'] = jkController.text;
    request.fields['kewarganegaraan'] = kewarganegaraanController.text;
    request.fields['agama'] = agamaController.text;
    request.fields['status_nikah'] = statusNikahController.text;
    request.fields['status_keluarga'] = statusKeluargaController.text;
    request.fields['pekerjaan'] = pekerjaanController.text;
    request.fields['pendidikan'] = pendidikanController.text;
    request.fields['id_surat'] = 'SR001'; // Atur dinamis sesuai jenis surat

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('foto1', _imageFile!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
      );
      _formKey.currentState?.reset();
      setState(() {
        _imageFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal kirim: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FORM SURAT KEMATIAN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0057A6),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Silakan isi data pelapor dan data almarhum untuk pengajuan surat kematian.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              buildInputField('Nama Almarhum (yang meninggal)', namaalmController),
              buildInputField('Nama Pelapor', namaController),
              buildInputField('NIK Pelapor', nikController),
              buildInputField('Tempat Lahir Pelapor', tempatLahirController),
              buildInputField('Tanggal Lahir Pelapor', tanggalLahirController),
              buildInputField('Golongan Darah Pelapor', golDarahController),
              buildInputField('Jenis Kelamin Pelapor', jkController),
              buildInputField('Kewarganegaraan Pelapor', kewarganegaraanController),
              buildInputField('Agama Pelapor', agamaController),
              buildInputField('Status Perkawinan Pelapor', statusNikahController),
              buildInputField('Status Keluarga Pelapor', statusKeluargaController),
              buildInputField('Pekerjaan Pelapor', pekerjaanController),
              buildInputField('Pendidikan Pelapor', pendidikanController),

              const SizedBox(height: 16),
              buildUploadField('Upload Foto KTP Pelapor'),
              const SizedBox(height: 26),

              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: submitPengajuan,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF0057A6),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0057A6), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0057A6), width: 2),
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
          border: Border.all(color: const Color(0xFF0057A6), width: 1.5),
        ),
        child: Center(
          child: _imageFile == null
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
