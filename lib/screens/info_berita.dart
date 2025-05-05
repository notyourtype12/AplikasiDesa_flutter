import 'package:flutter/material.dart';
import 'detail_berita.dart'; // ✅ Tambahkan import ini

class InfoBerita extends StatefulWidget {
  const InfoBerita({super.key});

  @override
  State<InfoBerita> createState() => _InfoBeritaState();
}

class _InfoBeritaState extends State<InfoBerita> {
  final List<String> berita = const [
    'Dina Lorenza Tegaskan Pentingnya 4 Pilar Kebangsaan...',
    'UMKM Tegal Dapat Bantuan Infrastruktur Baru...',
    'Sosialisasi Layanan Kependudukan oleh Disdukcapil...',
    'Digitalisasi Administrasi Desa Menuju Smart Village...',
    'Disdukcapil Launching Aplikasi Baru untuk Pelayanan...',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'INFO BERITA',
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
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: berita.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailBerita(judul: berita[index]),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/news.png',
                    height: 160,
                    width: double.infinity,
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
                    child: Text(
                      berita[index],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
