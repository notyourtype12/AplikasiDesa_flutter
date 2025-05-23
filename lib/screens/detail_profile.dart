import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({super.key});

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController kkController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); 
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('nama_lengkap') ?? 'Belum diatur';
      nikController.text = prefs.getString('nik') ?? 'Belum diatur';
      kkController.text = prefs.getString('no_kk') ?? 'Belum diatur';
      phoneController.text = prefs.getString('no_hp') ?? 'Belum diatur';
      emailController.text = prefs.getString('email') ?? 'Belum diatur';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UBAH INFO PROFIL',
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
        
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField('NIK', nikController, readOnly: true),
            buildTextField('No Kartu keluarga', kkController, readOnly: true),
            buildTextField('Nama lengkap', nameController),
            buildTextField('No Handphone', phoneController),
            buildTextField(
              'E-mail',
              emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile berhasil diperbarui'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0057A6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Disamakan dengan text field
                  ),
                ),
                child: Text(
                  'Ubah',
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

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final Color borderColor = readOnly ? const Color.fromARGB(255, 13, 103, 221)  : const Color(0xFF0057A6);
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
}
