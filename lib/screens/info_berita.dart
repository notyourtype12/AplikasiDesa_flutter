// Pastikan kamu import file yang sesuai
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_berita.dart';

class InfoBerita extends StatefulWidget {
  @override
  _InfoBeritaState createState() => _InfoBeritaState();
}

class _InfoBeritaState extends State<InfoBerita> {
  List<dynamic> beritaList = [];

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.10:8000/api/berita'),
    );

    if (response.statusCode == 200) {
      setState(() {
        beritaList = json.decode(response.body);
      });
    } else {
      print('Gagal memuat berita');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: beritaList.length,
      itemBuilder: (context, index) {
        final berita = beritaList[index];

        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            leading:
                berita['gambar'] != null
                    ? Image.network(
                      berita['gambar'],
                      width: 60,
                      fit: BoxFit.cover,
                    )
                    : Icon(Icons.image_not_supported),
            title: Text(berita['judul']),
            subtitle: Text(berita['created_at']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailBerita(beritaId: berita['id']),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
