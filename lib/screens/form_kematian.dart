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

class FormKematian extends StatefulWidget {
  const FormKematian({super.key});

  @override
  State<FormKematian> createState() => _FormKematianState();
}

class _FormKematianState extends State<FormKematian> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController golDarahController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController kewarganegaraanController =  TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  // final TextEditingController statusNikahController = TextEditingController(text: 'Belum Kawin');
  final TextEditingController statusKeluargaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
  final TextEditingController keperluanController = TextEditingController();
    bool isLoading = false;

  File? _foto1; // foto kk
  File? _foto2; // surat kematian
  File? _foto3; // ktp pelapor
  File? _foto4; // ktp terlapor

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

   Future<void> _submitForm() async {
    setState(() => isLoading = true); // Aktifkan loading

    final uri = Uri.parse('$baseURL/pengajuan');
    final request = http.MultipartRequest('POST', uri);

    request.fields['id_surat'] = 'S2025-003';
    request.fields['nik'] = nikController.text;
    request.fields['keperluan'] = keperluanController.text;
    request.fields['tanggal_diajukan'] = DateTime.now().toIso8601String();

    Future<void> addFile(String fieldName, File? file) async {
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fieldName, file.path),
        );
      }
    }

    await addFile('foto1', _foto1);
    await addFile('foto2', _foto2);
    await addFile('foto3', _foto3);
    await addFile('foto4', _foto4);

    try {
      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (res.statusCode == 200) {
        showCustomSnackbar(
          context: context,
          message: 'Pengajuan berhasil dikirim!',
          backgroundColor: Colors.green,
          icon: Icons.check_circle,
        );
      } else {
        String errorMessage = 'Gagal mengirim pengajuan.';
        try {
          final responseData = jsonDecode(res.body);
          if (responseData is Map) {
            if (responseData.containsKey('errors')) {
              errorMessage = responseData['errors'].values
                  .map((errList) => (errList as List).join(', '))
                  .join('\n');
            } else if (responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            }
          }
        } catch (_) {
          errorMessage = 'Response bukan JSON. Isi:\n${res.body}';
        }

        showCustomSnackbar(
          context: context,
          message: errorMessage,
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

    setState(() => isLoading = false); // Nonaktifkan loading
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PENGAJUAN  KEMATIAN',
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
            buildInputField(
              'Tempat Lahir',
              tempatLahirController,
              readOnly: true,
            ),
            buildInputField(
              'Tanggal Lahir',
              tanggalLahirController,
              readOnly: true,
            ),
            buildInputField(
              'Golongan Darah',
              golDarahController,
              readOnly: true,
            ),
            buildInputField('Jenis Kelamin', jkController, readOnly: true),
            buildInputField(
              'Kewarganegaraan',
              kewarganegaraanController,
              readOnly: true,
            ),
            buildInputField('Agama', agamaController, readOnly: true),
            // buildInputField('Status Perkawinan', statusNikahController, readOnly: true),
            buildInputField(
              'Status Keluarga',
              statusKeluargaController,
              readOnly: true,
            ),
            buildInputField('Pekerjaan', pekerjaanController, readOnly: true),
            buildInputField('Pendidikan', pendidikanController, readOnly: true),
            buildInputField('Nama Almarhum', keperluanController),
            const SizedBox(height: 16),
           buildUploadField('Kartu Keluarga', _foto1, (file) {
              setState(() => _foto1 = file);
            }),
            const SizedBox(height: 16),

            buildUploadField('Surat Kematian dari Rumah Sakit atau Desa', _foto2, (file) {
              setState(() => _foto2 = file);
            }),
            const SizedBox(height: 16),

            buildUploadField('KTP Pelapor', _foto3, (file) {
              setState(() => _foto3 = file);
            }),
            const SizedBox(height: 16),

            buildUploadField('KTP Terlapor (Yang Meninggal)', _foto4, (file) {
              setState(() => _foto4 = file);
            }),
            
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0057A6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2.5,
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
    final Color borderColor =
        readOnly
            ? const Color.fromARGB(255, 13, 103, 221)
            : const Color(0xFF0057A6);
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
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor, width: 2),
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
