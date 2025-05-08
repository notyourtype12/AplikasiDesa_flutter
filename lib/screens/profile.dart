import 'package:flutter/material.dart';
import '../screens/detail_profile.dart';
import '../screens/info_profile.dart';
import '../auth/LoginRegis.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nama = '';
  String _nik = '';
  String _noHp = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama_lengkap') ?? 'Nama tidak ditemukan';
      _nik = prefs.getString('nik') ?? 'NIK tidak ditemukan';
      _noHp = prefs.getString('no_hp') ?? 'No HP tidak ditemukan';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            
            color: Color(0xFF0057A6),
          ),
        ),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.25),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
        backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildProfileCard(),
            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text('Yakin ingin keluar?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(); 
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Loginregis(),
                                  ),
                                ); 
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  
                  backgroundColor: const Color.fromARGB(74, 255, 0, 0),
                 
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  ),
                  elevation: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.logout_outlined, color: Color.fromARGB(255, 255, 255, 255), size: 20),
                    SizedBox(width: 15),
                    Text(
                      'Keluar',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileCard() {
    return SizedBox(
      height: 160,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/devano.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.badge,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _nik,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(_noHp,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoProfile()),
                );
              },
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF4FD),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Color(0xFF0057A6), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Info Profil',
                          style: TextStyle(
                            color: Color(0xFF0057A6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF0057A6),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
