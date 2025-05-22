import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';
import '../models/pengajuandiajukan_model.dart';

class PengajuanView extends StatelessWidget {
  const PengajuanView({super.key});

  Future<List<StatusDiajukanModel>> fetchPengajuan() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      throw Exception('NIK tidak ditemukan di SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('$baseURL/statusdiajukan?nik=$nik'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => StatusDiajukanModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<StatusDiajukanModel>>(
        future: fetchPengajuan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final pengajuans = snapshot.data!;
          return ListView.builder(
            itemCount: pengajuans.length,
            itemBuilder: (context, index) {
              final item = pengajuans[index];
              return Card(
                margin: const EdgeInsets.all(19),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0057A6),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        item.namaSurat.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Diajukan Pada: ${item.tanggalDiajukan}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Surat Anda Sedang Ditinjau. \nMohon Tunggu Keputusan Dari Pihak Terkait.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${item.status}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: const [
                              Icon(
                                Icons.delete_outline,
                                color: Color(0xFF0057A6),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Hapus",
                                style: TextStyle(
                                  color: Color(0xFF0057A6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
