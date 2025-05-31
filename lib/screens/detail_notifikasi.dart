import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/globals.dart';

class DetailPengaduanScreen extends StatefulWidget {
  final int idPengaduan;

  const DetailPengaduanScreen({super.key, required this.idPengaduan});

  @override
  State<DetailPengaduanScreen> createState() => _DetailPengaduanScreenState();
}

class _DetailPengaduanScreenState extends State<DetailPengaduanScreen> {
  bool isLoading = true;
  Map<String, dynamic>? pengaduan;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    fetchDetailPengaduan();
  }

  Future<void> fetchDetailPengaduan() async {
    final url = Uri.parse('$baseURL/notifikasi/${widget.idPengaduan}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          pengaduan = data;
          isLoading = false;

          // Debug print foto1 path dan URL
          if (pengaduan != null &&
              pengaduan!['foto1'] != null &&
              pengaduan!['foto1'].toString().isNotEmpty) {
            print('Foto path: ${pengaduan!['foto1']}');
            print('Full URL: $baseURL/storage/${pengaduan!['foto1']}');
          } else {
            print('Foto1 kosong atau null');
          }
        });
      } else {
        setState(() {
          errorMsg =
              'Gagal mengambil data. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengaduan'),
        backgroundColor: const Color(0xFF0057A6),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMsg.isNotEmpty
              ? Center(child: Text(errorMsg, style: GoogleFonts.poppins()))
              : pengaduan == null
              ? Center(
                child: Text(
                  'Data tidak ditemukan',
                  style: GoogleFonts.poppins(),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                           
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.teal[50],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.message,
                                      size: 18,
                                      color: Colors.teal,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Ulasan Anda:',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.teal[800],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  pengaduan!['ulasan'] ?? 'Tidak ada pesan',
                                  style: GoogleFonts.poppins(fontSize: 15),
                                ),
                                if (pengaduan!['foto1'] != null &&
                                    pengaduan!['foto1']
                                        .toString()
                                        .isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      '${pengaduan!['foto1']}',
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                   
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Admin Desa',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                    3.1416,
                                  ), // rotasi 180 derajat horizontal
                                  child: const Icon(
                                    Icons.reply,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                ),

                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    pengaduan!['feedback'] ??
                                        'Belum ada tanggapan',
                                    style: GoogleFonts.poppins(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ======== INFO TAMBAHAN ========
                    // Row(
                    //   children: [
                    //     const Icon(Icons.category, color: Colors.grey),
                    //     const SizedBox(width: 6),
                    //     Expanded(
                    //       child: Text(
                    //         'Kategori: ${pengaduan!['kategori'] ?? '-'}',
                    //         style: GoogleFonts.poppins(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     const Icon(Icons.access_time, color: Colors.grey),
                    //     const SizedBox(width: 6),
                    //     Expanded(
                    //       child: Text(
                    //         'Waktu: ${pengaduan!['created_at'] ?? '-'}',
                    //         style: GoogleFonts.poppins(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
    );
  }

}
