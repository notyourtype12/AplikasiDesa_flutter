import 'package:digitalv/screens/form_aktakelahiran.dart';
import 'package:digitalv/screens/form_aktaperkawinan.dart';
import 'package:digitalv/screens/form_kartukeluarga.dart';
import 'package:digitalv/screens/form_ktp.dart';
import 'package:digitalv/screens/form_pindahpenduduk.dart';
import 'package:digitalv/screens/form_sktm.dart';
import 'package:digitalv/screens/form_suratmiskin.dart';
import 'package:flutter/material.dart';
import 'package:digitalv/screens/pengaduan.dart';
import 'package:digitalv/screens/form_pengajuan.dart';
import 'package:digitalv/screens/form_kematian.dart';
import 'package:digitalv/screens/info_berita.dart';
import 'package:digitalv/screens/detail_berita.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitalv/models/detail_berita.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isNavigating = false;

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
    {'icon': Icons.credit_card, 'label': 'KTP', 'color': const Color(0xFF455A64)},
    {
      'icon': Icons.money_sharp,
      'label': 'SKTM',
      'color': const Color.fromARGB(255, 255, 147, 7),
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
      'color': const Color.fromARGB(255, 167, 0, 17),
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Pernyataan Miskin',
      'color': const Color.fromARGB(255, 116, 53, 31),
    },
  ];

  Future<List<Berita>> fetchBeritaList() async {
   final response = await http.get(
      Uri.parse('$baseURL/berita'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Berita.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load berita');
    }
  }

  Color tintColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.white, 0.7)!;
  }

  String namaUser = 'User'; // Default

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Mengambil data dari SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      namaUser = prefs.getString('nama') ?? 'User';
    });
  }

  // Menyimpan data nama pengguna ke SharedPreferences (Misalnya setelah login)
  void _saveUserData(String nama) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('nama', nama); // Menyimpan nama di SharedPreferences
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
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),

                decoration: const BoxDecoration(
                  color: Color(0xFF0057A6), // warna biru
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: GoogleFonts.poppins(
                        color: Colors.white, 
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Text(
                       '$namaUser!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                                const Text(
                                  'Pengaduan!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lakukan pengaduan jika anda memiliki keluhan, saran, atau masukan.',
                                  style: TextStyle(
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
                                    children: const [
                                      Text(
                                        'Klik Disini',
                                        style: TextStyle(
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
                            // ... Kode navigasi Anda
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
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 5), // Hapus padding top
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Berita Terkini',
                          style: TextStyle(
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
                                  fontSize: 12,
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

                   const SizedBox(height: 15),
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

