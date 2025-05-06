import 'package:flutter/material.dart';
import 'package:digitalv/screens/pengaduan.dart';
import 'package:digitalv/screens/form_pengajuan.dart';
import 'package:digitalv/screens/form_kematian.dart';
import 'package:digitalv/screens/info_berita.dart';
import 'package:digitalv/screens/detail_berita.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final List<Map<String, dynamic>> layanan = const [
    {
      'icon': Icons.insert_drive_file,
      'label': 'Akta Kelahiran',
      'color': Color(0xFF1976D2),
    },
    {
      'icon': Icons.family_restroom,
      'label': 'Kartu Keluarga',
      'color': Color(0xFF388E3C),
    },
    {'icon': Icons.credit_card, 'label': 'KTP', 'color': Color(0xFF455A64)},
    {
      'icon': Icons.money_sharp,
      'label': 'SKTM',
      'color': Color.fromARGB(255, 255, 147, 7),
    },
    {
      'icon': Icons.diversity_3,
      'label': 'Akta Perkawinan',
      'color': Color(0xFF6A1B9A),
    },
    {
      'icon': Icons.airline_seat_flat,
      'label': 'Akta Kematian',
      'color': Color(0xFF607D8B),
    },
    {
      'icon': Icons.apartment,
      'label': 'Pindah Penduduk',
      'color': Color.fromARGB(255, 167, 0, 17),
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Pernyataan Miskin',
      'color': Color.fromARGB(255, 116, 53, 31),
    },
  ];

  final List<Map<String, String>> berita = const [
    {
      'judul': 'Perbaikan jalan utama dan pembangunan taman desa.',
      'tanggal': '04 Mei 2025',
      'gambar': 'assets/images/news.png',
    },
    {
      'judul': 'Peningkatan fasilitas air bersih untuk warga.',
      'tanggal': '02 Mei 2025',
      'gambar': 'assets/images/news.png',
    },
    {
      'judul': 'Pengaspalan jalan dan pembangunan ruang serbaguna.',
      'tanggal': '28 April 2025',
      'gambar': 'assets/images/news.png',
    },
  ];

  Color tintColor(Color baseColor) {
    return Color.lerp(baseColor, Colors.white, 0.7)!;
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: const Color(0xFF0057A6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'User!',
                      style: TextStyle(
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
                    const SizedBox(height: 25),
                    const Text(
                      'Kategori Layanan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: layanan.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final item = layanan[index];
                        final backgroundColor = tintColor(item['color']);
                        return GestureDetector(
                          onTap: () {
                            if (index == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormKematian(),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FormPengajuan(),
                                ),
                              );
                            }
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
                    Row(
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
                                builder: (context) => const InfoBerita(),
                              ),
                            );
                          },
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: berita.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final item = berita[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailBerita(
                                    judul: item['judul']!,
                                    tanggal: item['tanggal']!,
                                    gambar: item['gambar']!,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    item['gambar']!,
                                    height: 170,
                                    width: 250,
                                    fit: BoxFit.cover,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['judul']!,
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
                                          item['tanggal']!,
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
                      ),
                    ),
                    const SizedBox(height: 20),
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
