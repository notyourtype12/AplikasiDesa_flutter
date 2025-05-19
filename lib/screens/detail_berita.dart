import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailBerita extends StatefulWidget {
  final int beritaId;

  const DetailBerita({required this.beritaId});

  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  Map<String, dynamic>? berita;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.10:8000/api/berita/${widget.beritaId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        berita = json.decode(response.body);
      });
    } else {
      print('Gagal memuat detail berita');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (berita == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Detail Berita')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(berita!['judul'] ?? 'Detail')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (berita!['gambar'] != null)
              Image.network(berita!['gambar'], fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              berita!['judul'] ?? '',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              berita!['created_at'] ?? '',
              style: TextStyle(color: Colors.grey),
            ),
            Divider(height: 32),
            Text(berita!['isi'] ?? ''),
          ],
        ),
      ),
    );
  }
}
