import 'package:flutter/material.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({super.key});

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  final TextEditingController nameController =
      TextEditingController(text: 'Devano Danendra');
  final TextEditingController nikController =
      TextEditingController(text: '3510000000000000');
  final TextEditingController kkController =
      TextEditingController(text: '3521500000000002');
  final TextEditingController phoneController =
      TextEditingController(text: '085748220623');
  final TextEditingController emailController =
      TextEditingController(text: 'Devano@Gmail.Com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UBAH INFO PROFIL',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField('Nama lengkap', nameController),
            buildTextField('NIK', nikController, readOnly: true),
            buildTextField('No Kartu keluarga', kkController, readOnly: true),
            buildTextField('No Handphone', phoneController),
            buildTextField('E-mail', emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 30),
            SizedBox(
              width: 125,
              child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile berhasil diperbarui')),
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
                    'Ubah',
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

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0057A6),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0F6FF),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
