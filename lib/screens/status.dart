import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/my_tab_controller.dart';
import '../status/diajukan.dart';
import '../status/selesai.dart';
import '../status/ditolak.dart';
import 'package:google_fonts/google_fonts.dart';


class StatusTabScreen extends StatelessWidget {
  final MyTabController controller = Get.put(MyTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("STATUS",
             style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0057A6),
            )),
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Color(0xFF0057A6), //warna garis bawah
          tabs: [
            Tab(
              child: Text(
                "Diajukan",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0057A6),
                ),
              ),
            ),
            Tab(
              child: Text(
                "Selesai",
               style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0057A6),
              ),
              ),
            ),
            Tab(
              child: Text(
              "Ditolak",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0057A6),
              ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          PengajuanView(),
          DisetujuiView(),
          DitolakView(),
        ],
      ),
    );
  }
}
