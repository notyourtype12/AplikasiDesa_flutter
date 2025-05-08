import 'package:digitalv/screens/form_kematian.dart';
import 'package:flutter/material.dart';
import '../screens/form_pengajuan.dart';

class SuratScreen extends StatefulWidget {
  const SuratScreen({super.key});

  @override
  State<SuratScreen> createState() => _SuratScreenState();
}

class _SuratScreenState extends State<SuratScreen> {
  final TextStyle titleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  final TextStyle descStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey,
    fontWeight: FontWeight.w400,
  );
  final TextStyle btnTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );

  final double spacingBetweenTitleAndDesc = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'LAYANAN SURAT',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0057A6),
          ),
        ),
       
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.25),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 3 / 2.5,
          children: [
            buildCard(
              title: 'Akta Kelahiran',
              desc: 'Ajukan Akta Kelahiran Untuk Anak Anda',
              btnText: 'Ajukan',
              btnColor: Colors.blue.shade50,
              btnTextColor: Colors.blue,
              btnIcon: Icons.edit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'Kartu Keluarga',
              desc: 'Buat Atau Perbarui Kartu Keluarga',
              btnText: 'Buat',
              btnColor: Colors.green.shade50,
              btnTextColor: Colors.green,
              btnIcon: Icons.add_circle_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormKematian()),
                );
              },
            ),
            buildCard(
              title: 'KTP',
              desc: 'Urus e-KTP baru atau perpanjang masa berlaku',
              btnText: 'Urus',
              btnColor: Colors.orange.shade50,
              btnTextColor: Colors.orange,
              btnIcon: Icons.credit_card,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'SKTM',
              desc: 'Ajukan SKTM Untuk Keperluan Administrasi',
              btnText: 'Ajukan',
              btnColor: Colors.deepOrange.shade50,
              btnTextColor: Colors.deepOrange,
              btnIcon: Icons.edit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'Akta Perkawinan',
              desc: 'Daftarkan atau cetak ulang akta perkawinan Anda',
              btnText: 'Daftar',
              btnColor: Colors.purple.shade50,
              btnTextColor: Colors.purple,
              btnIcon: Icons.note_add,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'Akta Kematian',
              desc: 'Lapor dan urus akta kematian keluarga',
              btnText: 'Laporkan',
              btnColor: Colors.teal.shade50,
              btnTextColor: Colors.teal,
              btnIcon: Icons.check_circle,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'Pindah Penduduk',
              desc: 'Urus perpindahan domisili Anda',
              btnText: 'Urus',
              btnColor: Colors.red.shade50,
              btnTextColor: Colors.red,
              btnIcon: Icons.credit_card,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
            buildCard(
              title: 'Pernyataan Miskin',
              desc: 'Ajukan surat untuk keperluan bantuan sosial',
              btnText: 'Ajukan',
              btnColor: Colors.yellow.shade50,
              btnTextColor: Colors.orange,
              btnIcon: Icons.edit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormPengajuan()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required String desc,
    required String btnText,
    required Color btnColor,
    required Color btnTextColor,
    required IconData btnIcon,
    VoidCallback? onPressed,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: titleStyle)),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          SizedBox(height: spacingBetweenTitleAndDesc),
          Text(desc, style: descStyle),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(btnIcon, size: 16),
              label: Text(btnText, style: btnTextStyle),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: btnColor,
                foregroundColor: btnTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: btnTextColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
