import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AnalysisNotifier extends ChangeNotifier {
    Map<String, int> _categoryWiseMoney = {};
  int _totalMoney = 0;
  int _knownCategoryExpense = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isDataReady = false;
  bool get isDataReady => _isDataReady;
  
  set isDataReady(bool value) {
    _isDataReady = value;
    notifyListeners();
  }

  Map<String, int> get categoryWiseMoney => _categoryWiseMoney;
  set categoryWiseMoney(Map<String, int> value) {
    _categoryWiseMoney = value;
    notifyListeners();
  }

  int get totalMoney => _totalMoney;
  set totalMoney(int value) {
    _totalMoney = value;
    notifyListeners();
  }

  int get knownCategoryExpense => _knownCategoryExpense;
  set knownCategoryExpense(int value) {
    _knownCategoryExpense = value;
    notifyListeners();
  }

  DateTime? get startDate => _startDate;
  set startDate(DateTime? value) {
    _startDate = value;
    notifyListeners();
  }

  DateTime? get endDate => _endDate;
  set endDate(DateTime? value) {
    _endDate = value;
    notifyListeners();
  }

    String getMonthYear(DateTime dateTime) {
    return DateFormat('MMM yy').format(dateTime);
  }

  String getFormattedStartDate() {
    return getMonthYear(_startDate ?? DateTime.now());
  }

  String getFormattedEndDate() {
    return getMonthYear(_endDate ?? DateTime.now());
  }

    Future<void> loadChartData() async {
    isDataReady = false;
    await Future.delayed(const Duration(milliseconds: 500));
    isDataReady = true;
  }
}