// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MyTabController extends GetxController with SingleGetTickerProviderMixin {
//   late TabController tabController;

//   @override
//   void onInit() {
//     tabController = TabController(length: 3, vsync: this);
//     super.onInit();
//   }

//   void changeTab(int index) {
//     tabController.animateTo(index);
//   }

//   @override
//   void onClose() {
//     tabController.dispose();
//     super.onClose();
//   }
// }
// file: status_tab_screen.dart
// file: status_tab_screen.dart



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/my_tab_controller.dart';
import '../status/diajukan.dart';
import '../status/disetujui.dart';
import '../status/ditolak.dart';


class StatusTabScreen extends StatelessWidget {
  final MyTabController controller = Get.put(MyTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("STATUS",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            color: Color(0xFF0057A6),
            )),
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Color(0xFF0057A6), //warna garis bawah
          tabs: const [
            Tab(
              child: Text(
                "Diajukan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0057A6),
                ),
              ),
            ),
            Tab(
              child: Text(
                "Disetujui",
               style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0057A6),
              ),
              ),
            ),
            Tab(
              child: Text(
              "Ditolak",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
