import 'package:flutter/material.dart';
import '../screens/detail_profile.dart';
import '../screens/info_profile.dart';
import '../auth/LoginRegis.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (!mounted) return; // safety check
    setState(() {
      _nama = prefs.getString('nama') ?? 'Nama tidak ditemukan';
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
        title: Text(
          'PROFILE',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0057A6),
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
          children: <Widget>[
            buildProfileCard(),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 13, 13),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    Icon(Icons.logout_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 15),
                    Text(
                      'Keluar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
      height: 150,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/images/devano.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
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
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _noHp,
                              style: const TextStyle(color: Colors.grey),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Center(
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // <- ini juga
                        children: const <Widget>[
                          Icon(Icons.edit, color: Color(0xFF0057A6), size: 20),
                          SizedBox(width: 6),
                          Text(
                            'Info Profil',
                            style: TextStyle(
                              color: Color(0xFF0057A6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF0057A6),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.logout_rounded,
                  size: 60,
                  color: Color(0xFF0057A6),
                ),
                const SizedBox(height: 15),
                Text(
                  'Konfirmasi Keluar',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0057A6),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Apakah Anda yakin ingin keluar dari akun?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0057A6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
               onPressed: () async {
                          Navigator.pop(context);

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: const <Widget>[
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text("Anda telah keluar dari akun."),
                                ],
                              ),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );

                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => Loginregis()),
                            );
                          });
                        },

                        child: Text(
                          'Ya',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
