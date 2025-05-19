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
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SuratScreen(),
    StatusTabScreen(),
    ProfileScreen(),
  ];

  final List<Widget> _items = const [

    Icon(Icons.home, size: 25, color: Colors.white),
    Icon(Icons.mail, size: 25, color: Colors.white),
    Icon(Icons.history, size: 25, color: Colors.white),
    Icon(Icons.person, size: 25, color: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xFF0057A6),
        buttonBackgroundColor: Color(0xFF0057A6),
        height: 60,
        items: _items,
        index: _currentIndex,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
