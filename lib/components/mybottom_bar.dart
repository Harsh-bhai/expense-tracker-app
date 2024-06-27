import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {

  void _onItemTapped(int index,CommonNotifier commonNotifier) {
    // switch (index) {
    //   case 0:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const HomePage()),
    //     );
    //     break;
    //   case 1:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const AnalysisPage()),
    //     );
    //     break;
    //   case 2:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const CategoryPage()),
    //     );
    //     break;
    //   case 3:
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const AccountPage()),
    //     );
    //     break;
    // }
    setState(() {
      commonNotifier.selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context,listen: false);
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
          icon: Icon(Icons.account_circle_rounded),
          label: 'Account',
        ),
      ],
      currentIndex: commonNotifier.selectedIndex,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(index,commonNotifier),
    );
  }
}
