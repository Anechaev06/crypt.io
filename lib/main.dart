import 'package:flutter/material.dart';
import 'package:crypt_io/pages/course_page.dart';
import 'package:crypt_io/pages/modules_page.dart';
import 'package:crypt_io/themes/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypt.io",
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      CoursePage(),
      const ModulesPage(),
    ];
    return SafeArea(
      child: Scaffold(
        body: pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin),
              label: 'Course',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.polymer_rounded),
              label: 'Modules',
            ),
          ],
        ),
      ),
    );
  }
}
