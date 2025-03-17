// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Custom Bottom Navbar',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//       ),
//       home: const BottomNavBar(),
//     );
//   }
// }

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const Center(child: Text('Beranda Page', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Surat Page', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Riwayat Page', style: TextStyle(fontSize: 24))),
//     const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Container(
//           height: 70,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildNavItem(Icons.home, "Home", 0),
//               buildNavItem(Icons.mail, "Surat", 1),
//               buildNavItem(Icons.history, "Riwayat", 2),
//               buildNavItem(Icons.person, "Profile", 3),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildNavItem(IconData icon, String label, int index) {
//     bool isSelected = _selectedIndex == index;
//     return GestureDetector(
//       onTap: () => _onItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             decoration: BoxDecoration(
//               color: isSelected ? Colors.black12.withOpacity(0.2) : Colors.transparent,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Icon(icon, color: Colors.black, size: 28),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//               color: Colors.black.withOpacity(isSelected ? 1 : 0.6),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }