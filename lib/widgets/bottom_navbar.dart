import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/home.dart';
import '../screens/surat.dart';
import '../screens/status.dart';
import '../screens/profile.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  
  final List<Widget> _pages = [
    HomeScreen(),
    SuratScreen(),
    StatusTabScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],
      extendBody: true, 
      bottomNavigationBar: PhysicalModel(
        elevation: 8,
        color: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
        child: CurvedNavigationBar(
          height: 50,
          index: _page,
          backgroundColor: Colors.transparent,
          color: const Color(0xFF0057A6),
          buttonBackgroundColor: Colors.white,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          items: [
            Icon(Icons.home, size: 26, color: _page == 0 ? Color(0xFF0057A6) : Colors.white),
            Icon(Icons.mail, size: 26, color: _page == 1 ? Color(0xFF0057A6) : Colors.white),
            Icon(Icons.history, size: 26, color: _page == 2 ? Color(0xFF0057A6) : Colors.white),
            Icon(Icons.person, size: 26, color: _page == 3 ? Color(0xFF0057A6) : Colors.white),
          ],
        ),
      ),
    );
  }
}
