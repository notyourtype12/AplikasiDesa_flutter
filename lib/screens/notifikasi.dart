import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/globals.dart';
import 'package:timeago/timeago.dart' as timeago;


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('id', timeago.IdMessages()); // set locale id
    fetchLatestNotifikasi();
  }

Future<void> fetchLatestNotifikasi() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('nik') ?? '';

    if (nik.isEmpty) {
      print('NIK tidak ditemukan di SharedPreferences');
      setState(() => isLoading = false);
      return; // <-- penting agar keluar dari fungsi
    }

    try {
      final response = await http.get(
        Uri.parse('$baseURL/notifikasi?nik=$nik'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pengajuanList = data['pengajuan'] as List<dynamic>?;
        final pengaduanList = data['pengaduan'] as List<dynamic>?;

        final List<Map<String, dynamic>> fetched = [];

        if (pengajuanList != null) {
          for (var item in pengajuanList) {
            final rawTime = item['created_at'];
            final localTime = DateTime.parse(rawTime).toLocal();
            final now = DateTime.now();
            final diffSeconds = now.difference(localTime).inSeconds;

            // Debug log
            print('--- Pengajuan ---');
            print('Raw time: $rawTime');
            print('Parsed toLocal: $localTime');
            print('Now: $now');
            print('Selisih (detik): $diffSeconds');

            fetched.add({
              'title': 'Notifikasi Pengajuan',
              'message': item['pesan'],
              'time': rawTime,
            });
          }
        }

        if (pengaduanList != null) {
          for (var item in pengaduanList) {
            final rawTime = item['created_at'];
            final localTime = DateTime.parse(rawTime).toLocal();
            final now = DateTime.now();
            final diffSeconds = now.difference(localTime).inSeconds;

            // Debug log
            print('--- Pengaduan ---');
            print('Raw time: $rawTime');
            print('Parsed toLocal: $localTime');
            print('Now: $now');
            print('Selisih (detik): $diffSeconds');

            fetched.add({
              'title': 'Notifikasi Pengaduan',
              'message': item['pesan'],
              'time': rawTime,
            });
          }
        }

        // Sort berdasarkan waktu terbaru
        fetched.sort((a, b) => b['time'].compareTo(a['time']));

        setState(() {
          notifications = fetched;
          isLoading = false;
        });
      } else {
        print('Gagal mengambil notifikasi (${response.statusCode})');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'NOTIFIKASI',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0057A6),
          foregroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : notifications.isEmpty
              ? Center(
                child: Text(
                  'Tidak ada notifikasi',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: notifications.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Color(0xFF1976D2),
                      ),
                      title: Text(
                        notif['title'] ?? '',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        notif['message'] ?? '',
                        style: GoogleFonts.poppins(fontSize: 13),
                      ),
                      trailing: Text(
                        notif['time'] != null
                            ? timeago.format(
                              DateTime.parse(notif['time']).toLocal(),
                              locale: 'id',
                            )

                            : '',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),


                    ),
                  );
                },
              ),
    );
  }
}
