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

  bool _isDataReady = false;
  bool get isDataReady => _isDataReady;
  set isDataReady(bool value) {
    _isDataReady = value;
    notifyListeners();
  }

  Future<void> loadChartData() async {
    isDataReady = false;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate data loading
    isDataReady = true;
  }

// get month from dateTime
  String getMonthYear(DateTime dateTime) {
    return DateFormat('MMM yy').format(dateTime);
  }

  List<String> formatDateTime(DateTime dateTime) {
    // Format the date as "day monthname year"
    String formattedDate = DateFormat('d MMM yy').format(dateTime);

    // Format the time as "hour:minute AM/PM"
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return [formattedDate, formattedTime];
  }
}
