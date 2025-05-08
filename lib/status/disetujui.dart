import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/globals.dart';

class DisetujuiModel {
  final String nama_surat;
  final String updated_at;
  final String status;

  DisetujuiModel({
    required this.nama_surat,
    required this.updated_at,
    required this.status,
  });

  factory DisetujuiModel.fromJson(Map<String, dynamic> json) {
    return DisetujuiModel(
      nama_surat: json['nama_surat'],
      updated_at: json['updated_at'],
      status: json['status'],
    );
  }
}

class DisetujuiView extends StatelessWidget {
  const DisetujuiView({super.key});

  Future<List<DisetujuiModel>> fetchDisetujui() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      throw Exception('NIK tidak ditemukan di SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('$baseURL/statusselesai?nik=$nik'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => DisetujuiModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<DisetujuiModel>>(
        future: fetchDisetujui(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          }

          final disetujui = snapshot.data!;
          return ListView.builder(
            itemCount: disetujui.length,
            itemBuilder: (context, index) {
              final item = disetujui[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color:Color(0xFF28A745),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        item.nama_surat,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Body Content
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Disetujui Pada: ${item.updated_at}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                          ),),
                          const SizedBox(height: 8),
                          const Text(
                            'Terima Kasih! Surat Anda Telah Disetujui, Unduh Surat Pada Tombol Di Bawah Ini.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Text(
                          //   'Status: ${item.status}',
                          //   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 128, 128, 128),),
                          // ),
                          // const SizedBox(height: 8),

                          // Unduh Surat
                          Row(
                            children: [
                              const Icon(Icons.download_outlined, color: Color(0xFF0057A6)),
                              const SizedBox(width: 4),
                              Text(
                                "Unduh Surat",
                                style: const TextStyle(
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
