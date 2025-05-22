import 'package:flutter/material.dart';

class Berita {
  final String idberita;
  final String judul;
  final String tanggal;
  final String deskripsi;
  final String? gambar;
  final String nik;
  final String? nama;

  Berita({
    required this.idberita,
    required this.judul,
    required this.tanggal,
    required this.deskripsi,
    this.gambar,
    required this.nik,
    this.nama,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      idberita: json['idberita'],
      judul: json['judul'],
      tanggal: json['tanggal'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      nik: json['nik'],
      nama: json['nama'],
    );
  }
}
