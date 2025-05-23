import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/detail_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/ProfileController.dart';
import '../widgets/snackbarcustom.dart'; 

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

 @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File selected = File(pickedFile.path);
      setState(() {
        _image = selected;
      });

      // Panggil fungsi upload dari file terpisah
      await uploadFotoProfil(context, selected);
    } else {
      showCustomSnackbar(
        context: context,
        message: 'Tidak ada gambar dipilih',
        backgroundColor: Colors.orange,
        icon: Icons.warning,
      );
    }
  }

  Future<void> _initializeProfile() async {
    await getProfilFromApi(context); // Tunggu API selesai
    await _loadProfileData(); // Lalu refresh dari SharedPreferences
  }


  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nik = prefs.getString('nik') ?? 'Belum diatur';
      _noKK = prefs.getString('no_kk') ?? 'Belum diatur';
      _nama = prefs.getString('nama_lengkap') ?? 'Belum diatur';
      _noHP = prefs.getString('no_hp') ?? 'Belum diatur';
      _email = prefs.getString('email') ?? 'Belum diatur';
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
                            : const AssetImage('assets/images/devano.png')
                                as ImageProvider,
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailProfile(),
                            ),
                          );
                        },
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
                            Icon(Icons.edit, size: 16,
                            color: Color(0xFF0057A6),
                            ),
                          ],
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
