import 'package:digitalv/screens/form_aktakelahiran.dart';
import 'package:digitalv/screens/form_aktaperkawinan.dart';
import 'package:digitalv/screens/form_kartukeluarga.dart';
import 'package:digitalv/screens/form_ktp.dart';
import 'package:digitalv/screens/form_pindahpenduduk.dart';
import 'package:digitalv/screens/form_sktm.dart';
import 'package:digitalv/screens/form_suratmiskin.dart';
import 'package:digitalv/screens/info_profile.dart';
import 'package:digitalv/screens/notifikasi.dart';
import 'package:flutter/material.dart';
import 'package:digitalv/screens/pengaduan.dart';
import 'package:digitalv/screens/form_kematian.dart';
import 'package:digitalv/screens/info_berita.dart';
import 'package:digitalv/screens/detail_berita.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitalv/models/detail_berita.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/globals.dart';
import '../controllers/ProfileController.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isNavigating = false;
  String namaUser = 'User'; // Default
  String _fotoProfil = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // List layanan (menu utama)
  final List<Map<String, dynamic>> layanan = [
    {
      'icon': Icons.insert_drive_file,
      'label': 'Akta Kelahiran',
      'color': const Color(0xFF1976D2),
    },
    {
      'icon': Icons.family_restroom,
      'label': 'Kartu Keluarga',
      'color': const Color(0xFF388E3C),
    },
    {
      'icon': Icons.credit_card,
      'label': 'KTP',
      'color': const Color(0xFF455A64),
    },
    {
      'icon': Icons.money_sharp,
      'label': 'SKTM',
      'color': const Color(0xFFFF9307),
    },
    {
      'icon': Icons.diversity_3,
      'label': 'Akta Perkawinan',
      'color': const Color(0xFF6A1B9A),
    },
    {
      'icon': Icons.airline_seat_flat,
      'label': 'Akta Kematian',
      'color': const Color(0xFF607D8B),
    },
    {
      'icon': Icons.apartment,
      'label': 'Pindah Penduduk',
      'color': const Color(0xFFA70011),
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Pernyataan Miskin',
      'color': const Color(0xFF74351F),
    },
  ];

  // Fungsi untuk ambil daftar berita dari API
  Future<List<Berita>> fetchBeritaList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/berita'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Berita.fromJson(json)).toList();
      } else {
        print(
          'Request failed\nStatus: ${response.statusCode}\nBody: ${response.body}',
        );
        throw Exception(
          'Gagal memuat data berita. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception saat mengambil data berita: $e');
      throw Exception('Terjadi kesalahan saat memuat data berita');
    }
  }

  // Untuk membuat warna lebih soft
  Color tintColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.white, 0.7)!;
  }

  // Memuat ulang data profil
  Future<void> _refreshProfile() async {
    await getProfilFromApi(context); // Ambil data dari API
    await _loadUserData;
  }

  // Mengambil data nama dan foto dari SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaUser = prefs.getString('nama') ?? 'User';
      _fotoProfil = prefs.getString('foto_profil') ?? '';
    });
  }

  // Menyimpan data nama pengguna (misalnya setelah login)
  void _saveUserData(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', nama);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 45),
                decoration: const BoxDecoration(
                  color: Color(0xFF0057A6),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang,',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$namaUser 👋',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Notification Icon
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationScreen() ,
                            ),
                          );
                        },
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              // Optional: Add notification badge
                              // Positioned(
                              //   right: 0,
                              //   top: 0,
                              //   child: Container(
                              //     padding: EdgeInsets.all(2),
                              //     decoration: BoxDecoration(
                              //       color: Colors.red,
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     constraints: BoxConstraints(
                              //       minWidth: 16,
                              //       minHeight: 16,
                              //     ),
                              //     child: Text(
                              //       '3', // notification count
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 10,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //       textAlign: TextAlign.center,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Profile Photo
                    Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InfoProfile(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              _image != null
                                  ? FileImage(_image!)
                                  : _fotoProfil.isNotEmpty
                                  ? NetworkImage(_fotoProfil)
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                
                padding: const EdgeInsets.all(20),
                
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0057A6), Color(0xFF003D73)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  'Pengaduan!',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                 Text(
                                  'Lakukan pengaduan jika anda memiliki keluhan, saran, atau masukan.',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Pengaduan(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFDCC478),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Klik Disini',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset('assets/images/boy.png', width: 100),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                     Text(
                      'Kategori Layanan',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets
                              .zero, // Menghilangkan padding default dari GridView
                      itemCount: layanan.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final item = layanan[index];
                        final backgroundColor = tintColor(item['color']);
                        return GestureDetector(
                          onTap: () async {
                            if (_isNavigating) return; // Cegah push ganda
                              _isNavigating = true;
                            Widget targetPage;

                            switch (index) {
                              case 0:
                                targetPage = FormAktakelahiran();
                                break;
                              case 1:
                                targetPage = FormKartukeluarga();
                                break;
                              case 2:
                                targetPage = FormKtp();
                                break;
                              case 3:
                                targetPage = FormSktm();
                                break;
                              case 4:
                                targetPage = FormAktaPerkawinan();
                                break;
                              case 5:
                                targetPage = FormKematian();
                                break;
                              case 6:
                                targetPage = FormPindahpenduduk();
                                break;
                              case 7:
                                targetPage = FormSuratmiskin();
                                break;
                              default:
                                _isNavigating = false;
                                return; // tidak ada aksi
                            }
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => targetPage),
                        );

                        _isNavigating = false; // aktifkan kembali setelah kembali dari push


                          
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(item['icon'], color: item['color']),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item['label'],
                                style: const TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                   
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 15), // Hapus padding top
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Berita Terkini',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoBerita(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // Mengurangi padding bawaan TextButton
                            minimumSize: Size.zero, // Mengurangi minimum size
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mengurangi area tap
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                   const SizedBox(height: 20),
                    SizedBox(
                        height: 170,
                        child: FutureBuilder<List<Berita>>(
                          future: fetchBeritaList(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Gagal memuat berita'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Tidak ada berita'));
                            }

                            final beritaList = snapshot.data!;

                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: beritaList.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final item = beritaList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailBerita(beritaId: item.idberita),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        item.gambar != null
                                            ? Image.network(
                                                item.gambar!,
                                                height: 170,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                height: 170,
                                                width: 250,
                                                color: Colors.grey,
                                                child: const Center(child: Text('No Image')),
                                              ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          height: 60,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black87,
                                                  Color.fromARGB(221, 64, 64, 64),
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 10,
                                          right: 10,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.judul,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item.tanggal,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )

                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

