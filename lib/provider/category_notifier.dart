import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/listtile_model.dart';

class CateogryNotifier extends ChangeNotifier {
  final List<ListTileModel> _expenseCategories = [];

  final List<ListTileModel> _incomeCategories = [];

  List<ListTileModel> get expenseCategories => _expenseCategories;
  List<ListTileModel> get incomeCategories => _incomeCategories;

// get categories from hive
  void getCategories() {
    final box = Hive.box<ListTileModel>("categories");
    
    notifyListeners();
  }
  void updateCategories() {
    final box = Hive.box<ListTileModel>("categories");
    notifyListeners();
  }
}