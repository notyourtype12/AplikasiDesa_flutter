import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';

class PengajuanModel {
  final String nama_surat;
  final String tanggal_diajukan;
  final String status;

  PengajuanModel({ //constructor
    required this.nama_surat,
    required this.tanggal_diajukan,
    required this.status,
  });

  factory PengajuanModel.fromJson(Map<String, dynamic> json) { //ubah json ke objek
    return PengajuanModel(
      nama_surat: json['nama_surat'],
      tanggal_diajukan: json['tanggal_diajukan'],
      status: json['status'],
    );
  }
}

class PengajuanView extends StatelessWidget {
  const PengajuanView({super.key});

  Future<List<PengajuanModel>> fetchPengajuan() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? ''; //ambil nik dari login

    if (nik.isEmpty) {
      throw Exception('NIK tidak ditemukan di SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('$baseURL/statusdiajukan?nik=$nik'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => PengajuanModel.fromJson(item)).toList();

    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    
    //menunggu data dari API dan balikin data dari api
      body: FutureBuilder<List<PengajuanModel>>(
        future: fetchPengajuan(), //memanggil data http
        builder: (context, snapshot) { //snapsot handling dari future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

//manampilkan data ke list view
          final pengajuans = snapshot.data!;
          return ListView.builder(
            itemCount: pengajuans.length,
            itemBuilder: (context, index) { // index tu macam arraynya gitu 
              final item = pengajuans[index];
              return Card(
                color: Colors.white, 
                margin: const EdgeInsets.all(19), // jarak antar carrd tengah
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity, // lebar card
                      height: 50,
                      padding: const EdgeInsets.all(12), // padding card
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 87, 166), // Biru atas card
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Text(
                        item.nama_surat.toUpperCase(),
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
                            "Diajukan Pada: ${item.tanggal_diajukan}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Surat Anda Sedang Ditinjau. Mohon Tunggu Keputusan Dari Pihak Terkait.',
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
                              Icon(Icons.delete_outline, color: Color(0xFF0057A6)),
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
