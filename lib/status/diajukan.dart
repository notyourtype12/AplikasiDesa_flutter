import 'package:flutter/material.dart';
import '../../config/statusApi.dart';
import '../../model/status_model.dart';

class PengajuanView extends StatelessWidget {
  const PengajuanView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PengajuanModel>>(
      future: ApiService.fetchPengajuan('acc rt'),
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
              margin: const EdgeInsets.all(10),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F2FB),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Text(
                      item.nama_surat.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Diajukan Pada: ${item.tanggal_diajukan}"),
                        const SizedBox(height: 8),
                        const Text('"Surat Anda Sedang Ditinjau. Mohon Tunggu Keputusan Dari Pihak Terkait."'),
                        const SizedBox(height: 8),
                        Text("Status: ${item.status}"),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.delete_outline, color: Colors.blue),
                            SizedBox(width: 4),
                            Text("Hapus", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
