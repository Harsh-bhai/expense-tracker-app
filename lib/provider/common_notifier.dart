import 'package:expense_tracker/screens/about_page.dart';
import 'package:expense_tracker/screens/analysis_page.dart';
import 'package:expense_tracker/screens/categories_page.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonNotifier extends ChangeNotifier {
  List<Widget> screens = [
    const HomePage(),
    const AnalysisPage(),
    const CategoryPage(),
    const AboutPage()
  ];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }



  // ============= UTILS =============


  String getMonthYear(DateTime dateTime) {
    return DateFormat('MMM yy').format(dateTime);
  }

  List<String> formatDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('d MMM yy').format(dateTime);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return [formattedDate, formattedTime];
  }
}
