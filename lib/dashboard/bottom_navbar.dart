import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../dashboard/home_screen.dart';
import '../dashboard/makanan_screen.dart';
import '../dashboard/minuman_screen.dart';
import '../dashboard/pesanan_screen.dart';
import '../dashboard/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  //list hlmn berdasarkan index
  final List<Widget> _pages = [
    const HomeScreen(),
    const MakananScreen(),
    const MinumanScreen(),
    const PesananScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle:true,
        title: const Text('BottomNavBar', style: TextStyle(color: Colors.white),),
      ),
      body: _pages[_page], //menampilkan hlmn sesuai index
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.lightBlue,
        color: Colors.lightBlue,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.lunch_dining, size: 26, color: Colors.white),
          Icon(Icons.wine_bar, size: 26, color: Colors.white),
          Icon(Icons.menu_book, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),

        ],
        onTap: (index) {
          setState(() {
            _page = index; //gant hlmn sesuai index
          });
        },
      ),
    );
  }
}