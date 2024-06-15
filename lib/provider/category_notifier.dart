import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/hive_listtile_model.dart'; // Import the Hive-adapted model

class CategoryNotifier extends ChangeNotifier {
  List<dynamic> _expenseCategories = [];
  List<dynamic> _incomeCategories = [];

  List<dynamic> get expenseCategories => _expenseCategories;
  List<dynamic> get incomeCategories => _incomeCategories;

  // box instance 
  final Box<List<dynamic>> box = Hive.box<List<dynamic>>('categoryBox'); 


 void getCategories() {
    _expenseCategories = box.get('ExpenseCategoryArray', defaultValue: [])?.cast<dynamic>() ?? [];
    _incomeCategories = box.get('IncomeCategoryArray', defaultValue: [])?.cast<dynamic>() ?? [];
    notifyListeners();
  }

  void updateCategories() {
    box.put('ExpenseCategoryArray', _expenseCategories);
    box.put('IncomeCategoryArray', _incomeCategories);
    notifyListeners();
  }

  void addCategory(dynamic category) {
    _expenseCategories.add(category); // Add category to local list
    updateCategories();
  }

  void deleteCategory(dynamic category) {
    _expenseCategories.remove(category);
    updateCategories();
  }

  void addIncomeCategory(dynamic category) {
    _incomeCategories.add(category);
    updateCategories();
  }

  void deleteIncomeCategory(dynamic category) {
    _incomeCategories.remove(category);
    updateCategories();
  }

  void deleteAllExpenseCategories() {
    _expenseCategories = [];
    updateCategories();
  }

  void deleteAllIncomeCategories() {
    _incomeCategories = [];
    updateCategories();
  }
}
