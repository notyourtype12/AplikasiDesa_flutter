import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import '../config/globals.dart';
import '../models/detail_berita.dart';

class DetailBerita extends StatefulWidget {
  final String beritaId;

  const DetailBerita({required this.beritaId, Key? key}) : super(key: key);

  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  Berita? berita;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/berita/${widget.beritaId}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          berita = Berita.fromJson(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load detail berita');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetch detail berita: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Berita', style: GoogleFonts.poppins())),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (berita == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Berita', style: GoogleFonts.poppins())),
        body: Center(
          child: Text(
            'Data berita tidak ditemukan',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          berita!.judul,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (berita!.gambar != null)
              Image.network(berita!.gambar!, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              berita!.judul,
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              berita!.tanggal,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              berita!.deskripsi,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
