// import 'dart:convert';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter/material.dart';
// import '../config/globals.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     AwesomeNotifications().initialize(null, [
//       NotificationChannel(
//         channelKey: 'basic_channel',
//         channelName: 'Basic Notifications',
//         channelDescription: 'Notifikasi status surat',
//         defaultColor: Colors.blue,
//         importance: NotificationImportance.High,
//       ),
//     ]);

//     final nik = inputData?['nik'];
//     if (nik == null) return Future.value(true);

//     final response = await http.get(
//       Uri.parse('$baseURL/statusdiajukan?nik=$nik'),
//     );
//     if (response.statusCode != 200) return Future.value(true);

//     final List data = json.decode(response.body);
//     final prefs = await SharedPreferences.getInstance();

//     for (var item in data) {
//       final status = item['status'];
//       final id = item['id_pengajuan'].toString();
//       final nama = item['nama_surat'];
//       final lastStatus = prefs.getString('status_$id');

//       if (lastStatus != null && lastStatus != status) {
//         await AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: id.hashCode,
//             channelKey: 'basic_channel',
//             title: 'Status Surat Berubah',
//             body: 'Status surat $nama berubah menjadi $status',
//           ),
//         );
//       }

//       await prefs.setString('status_$id', status);
//     }

//     return Future.value(true);
//   });
// }
