import 'package:expense_tracker/screens/account_page.dart';
import 'package:expense_tracker/screens/analysis_page.dart';
import 'package:expense_tracker/screens/categories_page.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';

class CommonNotifier extends ChangeNotifier {
  List<Widget> screens = [
    const HomePage(),
    const AnalysisPage(),
    const CategoryPage(),
    const AccountPage()
  ];
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}
