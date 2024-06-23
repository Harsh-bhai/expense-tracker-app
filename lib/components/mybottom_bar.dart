import 'package:expense_tracker/screens/account_page.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _selectedIndex == 0
          ? const HomePage()
          : const AccountPage()),
    );
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped);
  }
}
