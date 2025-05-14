import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';

class DitolakModel {
  //data yg dikrim
  final String nama_surat;
  final String status;
  final String keterangan_ditolak;
  final String updated_at;

  DitolakModel({ 
    required this.nama_surat,
    required this.status,
    required this.keterangan_ditolak,
    required this.updated_at,
  });

//menampilkan dari json ke ui 
  factory DitolakModel.fromJson(Map<String, dynamic> json) {
    return DitolakModel(
      nama_surat: json['nama_surat'],
      status: json['status'],
      keterangan_ditolak: json['keterangan_ditolak'],
      updated_at: json['updated_at'],
    );
  }
}

class DitolakView extends StatelessWidget {
  const DitolakView({super.key});

//menampilkan data,  handling
  Future<List<DitolakModel>> fetchDitolak() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      throw Exception('NIK tidak ditemukan di SharedPreferences');
    }

    final response = await http.get(
      Uri.parse('$baseURL/statusditolak?nik=$nik'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => DitolakModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      
      //menunggu data dari API dan balikin data dari api
      //futurebuikd mengambil data dari futurre fecthditolak
      body: FutureBuilder<List<DitolakModel>>(
        future: fetchDitolak(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data ditolak"));
          }

          final ditolak = snapshot.data!;
          return ListView.builder(
            itemCount: ditolak.length,
            itemBuilder: (context, index) {
              final item = ditolak[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
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
                        color: Color.fromARGB(255, 185, 46, 59),
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
                            "Ditolak Pada: ${item.updated_at}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Keterangan Ditolak: ${item.keterangan_ditolak}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${item.status}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 128, 128, 128),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                           Row(
                            children: const [
                              Icon(Icons.delete_outline, 
                                color: Color.fromARGB(255, 185, 46, 59),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Hapus",
                                style: TextStyle(
                                color: Color.fromARGB(255, 185, 46, 59),
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
