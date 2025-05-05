// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class FormPengajuan extends StatefulWidget {
//   const FormPengajuan({super.key});

//   @override
//   State<FormPengajuan> createState() => _FormPengajuanState();
// }

// class _FormPengajuanState extends State<FormPengajuan> {
//   File? _imageFile;

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'FORM PENGAJUAN',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF0057A6),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 2,
//         shadowColor: Colors.black.withOpacity(0.25),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               buildInputField('Nama lengkap'),
//               const SizedBox(height: 16),
//               buildInputField('NIK'),
//               const SizedBox(height: 16),
//               buildInputField('Tempat Lahir'),
//               const SizedBox(height: 16),
//               buildInputField('Tanggal Lahir'),
//               const SizedBox(height: 16),
//               buildInputField('Golongan Darah'),
//               const SizedBox(height: 16),
//               buildInputField('Jenis Kelamin'),
//               const SizedBox(height: 16),
//               buildInputField('Kewarganegaraan'),
//               const SizedBox(height: 16),
//               buildInputField('Agama'),
//               const SizedBox(height: 16),
//               buildInputField('Status Perkawinan'),
//               const SizedBox(height: 16),
//               buildInputField('Status Keluarga'),
//               const SizedBox(height: 16),
//               buildInputField('Pekerjaan'),
//               const SizedBox(height: 16),
//               buildInputField('Pendidikan'),
//               const SizedBox(height: 16),
//               buildInputField('Keperluan'),
//               const SizedBox(height: 16),
//               buildUploadField('Upload Foto KTP'),
//               const SizedBox(height: 26),
//               SizedBox(
//                 width: 125,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF0057A6),
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: const Text(
//                     'Kirim',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInputField(String label) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(
//           color: Color(0xFF0057A6),
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//           horizontal: 16,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF0057A6),
//             width: 1.5,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF0057A6),
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildUploadField(String title) {
//     return InkWell(
//       onTap: _pickImage,
//       child: Container(
//         width: double.infinity,
//         height: 146,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: const Color(0xFF0057A6),
//             width: 1.5,
//           ),
//         ),
//         child: Center(
//           child: _imageFile == null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/images/upload.png', width: 50, height: 50),
//                     const SizedBox(height: 8),
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Color(0xFF0057A6),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 )
//               : ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.file(
//                     _imageFile!,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  final TextEditingController statusNikahController = TextEditingController();
  final TextEditingController statusKeluargaController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
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

  Future<void> submitPengajuan() async {
    final uri = Uri.parse('http://127.0.0.1:8000/api/pengajuan'); // Ganti dengan IP server Laravel Anda
    var request = http.MultipartRequest('POST', uri);

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
    request.fields['keperluan'] = keperluanController.text;
    request.fields['id_surat'] = 'SR001'; // contoh id surat, bisa dinamis

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('foto1', _imageFile!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengajuan berhasil dikirim!')),
      );
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildInputField('Nama lengkap', namaController),
            buildInputField('NIK', nikController),
            buildInputField('Tempat Lahir', tempatLahirController),
            buildInputField('Tanggal Lahir', tanggalLahirController),
            buildInputField('Golongan Darah', golDarahController),
            buildInputField('Jenis Kelamin', jkController),
            buildInputField('Kewarganegaraan', kewarganegaraanController),
            buildInputField('Agama', agamaController),
            buildInputField('Status Perkawinan', statusNikahController),
            buildInputField('Status Keluarga', statusKeluargaController),
            buildInputField('Pekerjaan', pekerjaanController),
            buildInputField('Pendidikan', pendidikanController),
            buildInputField('Keperluan', keperluanController),
            const SizedBox(height: 16),
            buildUploadField('Upload Foto KTP'),
            const SizedBox(height: 26),
            SizedBox(
              width: 125,
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
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
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
