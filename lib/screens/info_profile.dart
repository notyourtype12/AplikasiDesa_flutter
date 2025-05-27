import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/detail_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/ProfileController.dart';
import '../widgets/snackbarcustom.dart'; 
import 'package:image_picker/image_picker.dart'; // Ambil gambar dari galeri/kamera
import 'package:image_cropper/image_cropper.dart'; // Crop gambar
import 'package:image_cropper/image_cropper.dart' as cropper;

class InfoProfile extends StatefulWidget {
  const InfoProfile({super.key});

  @override
  State<InfoProfile> createState() => _InfoProfileState();
}

class _InfoProfileState extends State<InfoProfile> {
  File? _image;

  String _nik = '';
  String _noKK = '';
  String _nama = '';
  String _noHP = '';
  String _email = '';
  String _fotoProfil = '';

 @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Crop gambar terlebih dahulu
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto',
            toolbarColor: const Color(0xFF0057A6),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Crop Foto'),
        ],
      );

      if (croppedFile != null) {
        File imageFile = File(croppedFile.path); // Konversi ke File
        setState(() {
          _image = imageFile;
        });

        await uploadFotoProfil(context, _image!);
      } else {
        showCustomSnackbar(
          context: context,
          message: 'Pemotongan gambar dibatalkan',
          backgroundColor: Colors.orange,
          icon: Icons.warning,
        );
      }
    } else {
      showCustomSnackbar(
        context: context,
        message: 'Tidak ada gambar dipilih',
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
    }
  }


  Future<void> _refreshProfile() async {
    await getProfilFromApi(context);  
    await _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final nik = prefs.getString('nik') ?? 'Belum diatur';
    final noKK = prefs.getString('no_kk') ?? 'Belum diatur';
    final nama = prefs.getString('nama_lengkap') ?? 'Belum diatur';
    final noHP = prefs.getString('no_hp') ?? 'Belum diatur';
    final email = prefs.getString('email') ?? 'Belum diatur';
    final fotoProfil = prefs.getString('foto_profil') ?? '';

    // Logging ke console

    setState(() {
      _nik = nik;
      _noKK = noKK;
      _nama = nama;
      _noHP = noHP;
      _email = email;
      _fotoProfil = fotoProfil;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'PROFILE',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0057A6),
          ),
        ),
        
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.25),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailProfile()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55, 
                    backgroundImage:
                        _image != null
                             ? FileImage(_image!)
                            : (_fotoProfil.isNotEmpty
                                ? NetworkImage(_fotoProfil)
                                : null),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImageAndUpload,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                                      color: Color(0xFF0057A6),

                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Info Profil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                   InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailProfile(),
                            ),
                          );

                          if (result == true) {
                            await _refreshProfile(); 
                          }
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: const [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0057A6),
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.edit,
                                size: 16,
                                color: Color(0xFF0057A6),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 16),
                  buildProfileRow('NIK', _nik),
                  buildProfileRow('No Kartu Keluarga', _noKK),
                  buildProfileRow('Nama Lengkap', _nama),
                  buildProfileRow('No Handphone', _noHP),
                  buildProfileRow('E-Mail', _email),
                  
                  const SizedBox(height: 8),
                  InkWell(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const UbahPasswordPage(),
                    //     ),
                    //   );
                    // },
                    child: Text(
                      'Ubah Password',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF0057A6),
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  Widget buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
