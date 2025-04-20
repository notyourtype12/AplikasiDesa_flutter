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
import '../view/status/diajukan.dart';
import '../view/status/disetujui.dart';
import '../view/status/ditolak.dart';


class StatusTabScreen extends StatelessWidget {
  final MyTabController controller = Get.put(MyTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STATUS"),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: "Diajukan"),
            Tab(text: "Disetujui"),
            Tab(text: "Ditolak"),
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
