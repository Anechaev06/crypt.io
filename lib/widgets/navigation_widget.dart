import 'package:crypt_io/pages/profile_page.dart';
import 'package:crypt_io/pages/swap_page.dart';
import 'package:flutter/material.dart';
import '../pages/course_page.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    CoursePage(),
    SwapPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: 'Course',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_rounded),
              label: 'Swap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
