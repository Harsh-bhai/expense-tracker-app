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
    _expenseCategories = box.get('ExpenseCategoryArray')?.cast<dynamic>() ?? [];
    _incomeCategories = box.get('IncomeCategoryArray')?.cast<dynamic>() ?? [];
    notifyListeners();
  }

  void updateHive() {
    box.put('ExpenseCategoryArray', _expenseCategories);
    box.put('IncomeCategoryArray', _incomeCategories);
    notifyListeners();
  }

  void addCategory(dynamic category,
      {bool expense = false, bool income = false}) {
    if (expense) {
      _expenseCategories.add(category);
    }
    if (income) {
      _incomeCategories.add(category);
    }
    updateHive();
  }

  // Function to update an existing category
  void updateCategory(HiveListTileModel updatedCategory,
      {bool expense = false, bool income = false}) {
    if (expense) {
      int index = _expenseCategories.indexWhere(
          (category) => category.categoryName == updatedCategory.categoryName);
      if (index != -1) {
        _expenseCategories[index] = updatedCategory;
      }
    }
    if (income) {
      int index = _incomeCategories.indexWhere(
          (category) => category.categoryName == updatedCategory.categoryName);
      if (index != -1) {
        _incomeCategories[index] = updatedCategory;
      }
    }
    updateHive();
  }

  void deleteCategory(dynamic category,
      {bool expense = false, bool income = false}) {
    if (expense) {
      _expenseCategories.remove(category);
    }
    if (income) {
      _incomeCategories.remove(category);
    }
    updateHive();
  }

  void deleteAllCategories({bool expense = false, bool income = false}) {
    if (expense) {
      _expenseCategories = [];
    }
    if (income) {
      _incomeCategories = [];
    }
    updateHive();
  }
}
