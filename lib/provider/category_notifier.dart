import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/hive_listtile_model.dart'; // Import the Hive-adapted model

class CategoryNotifier extends ChangeNotifier {
  List<dynamic> _expenseCategories = [];
  List<dynamic> _incomeCategories = [];
  Map<int, String> _userSavedCategoryMap = {};

  List<dynamic> get expenseCategories => _expenseCategories;
  List<dynamic> get incomeCategories => _incomeCategories;
  Map<int, String> get userSavedCategoryMap => _userSavedCategoryMap;


  // box instance
  final Box<List<dynamic>> box = Hive.box<List<dynamic>>('categoryBox');
  final maps = Hive.box('maps');

  void getCategories() {
    _expenseCategories = box.get('ExpenseCategoryArray')?.cast<dynamic>() ?? [];
    _incomeCategories = box.get('IncomeCategoryArray')?.cast<dynamic>() ?? [];
    _userSavedCategoryMap = maps.get('userSavedCategoryMap')?.cast<int, String>() ?? {};
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

  void saveCategoryToMap(int id, String name) {
    _userSavedCategoryMap[id] = name;
    maps.put('userSavedCategoryMap', _userSavedCategoryMap);
    notifyListeners();
    print({"map: ${_userSavedCategoryMap[id]} , Id: $id , Name: $name"});
  }

  // get the category from userSavedCategoryMap by id and return the name

  String getCategoryNameById(int id) {
    return _userSavedCategoryMap[id] ?? '';
  }

  // create a method to find the category from expenseCategories or incomeCategories which matches category title

  HiveListTileModel? findCategory(String name, {bool isDebit = false}) {
    HiveListTileModel? category;
    if(isDebit){
      for (var element in _expenseCategories) {
      if (element.title == name) {
        category = element;
      }
    }
    }
    else{
      for (var element in _incomeCategories) {
      if (element.title == name) {
        category = element;
      }
    }
    }
    return category;
  }

}

// save the selected category to hive
// save as map
// get the selected category from hive
// display correct cateogry at correct message
