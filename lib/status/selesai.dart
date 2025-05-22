import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/globals.dart';
import '../models/pengajuanselesai_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';


class DisetujuiView extends StatelessWidget {
  const DisetujuiView({super.key});

  // Future<String?> pickFolder() async {
  //   String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //   return selectedDirectory; // null kalau batal
  // }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          return false;
        }
      }
    }
    return true;
  }

  Future<List<StatusSelesaiModel>> fetchDisetujui() async {
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
      return data.map((item) => StatusSelesaiModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<StatusSelesaiModel>>(
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
                        item.namaSurat,
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
                            'Disetujui Pada: ${item.updatedAt}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 128, 128, 128),
                          ),),
                          const SizedBox(height: 8),
                          const Text(
                            'Terima Kasih! Surat Anda Telah Disetujui,\nUnduh Surat Pada Tombol Di Bawah Ini.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                       InkWell(
                            onTap: () async {
                              final url = item.filePdf;
                              print('Mencoba download file: $url');

                              try {
                                final fileName = url.split('/').last;

                                // Tentukan folder default Download Android
                                final directory = Directory(
                                  '/storage/emulated/0/Download',
                                );
                                final filePath = '${directory.path}/$fileName';

                                Dio dio = Dio();
                                await dio.download(url, filePath);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'File berhasil diunduh di $filePath',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Error saat download file: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Gagal download file: $e'),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.download_outlined,
                                  color: Color(0xFF0057A6),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Unduh Surat",
                                  style: TextStyle(
                                    color: Color(0xFF0057A6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
