import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  void _onItemTapped(int index, CommonNotifier commonNotifier) {
    setState(() {
      commonNotifier.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    CommonNotifier commonNotifier =
        Provider.of<CommonNotifier>(context, listen: false);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label: 'Analysis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_rounded),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About us',
        ),
      ],
      currentIndex: commonNotifier.selectedIndex,
      selectedItemColor: Colors.green.shade800,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(index, commonNotifier),
    );
  }
}
