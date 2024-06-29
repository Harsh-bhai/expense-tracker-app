import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import '../models/hive_listtile_model.dart'; // Import the Hive-adapted model

class CategoryNotifier extends ChangeNotifier {
  List<dynamic> _expenseCategories = [];
  List<dynamic> _incomeCategories = [];

  // saves selected category name with message id
  Map<int, String> _userSavedCategoryMap = {};
  
  // saves category name with list of message ids
  final Map<String, List<int>> _categoryMapExpense = {};
  final Map<String, List<int>> _categoryMapIncome = {};

  List<dynamic> get expenseCategories => _expenseCategories;
  List<dynamic> get incomeCategories => _incomeCategories;
  Map<int, String> get userSavedCategoryMap => _userSavedCategoryMap;
  Map<String, List<int>> get categoryMapExpense => _categoryMapExpense;
  Map<String, List<int>> get categoryMapIncome => _categoryMapIncome;

  

  // box instance
  final Box<List<dynamic>> box = Hive.box<List<dynamic>>('categoryBox');
  final maps = Hive.box('maps');

  void getCategories() {
    _expenseCategories = box.get('ExpenseCategoryArray')?.cast<dynamic>() ?? [];
    _incomeCategories = box.get('IncomeCategoryArray')?.cast<dynamic>() ?? [];
    _userSavedCategoryMap = maps.get('userSavedCategoryMap')?.cast<int, String>() ?? {};
    SchedulerBinding.instance.addPostFrameCallback((_) {
    notifyListeners();
    });
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
          (category) => category.title == updatedCategory.title);
      if (index != -1) {
        _expenseCategories[index] = updatedCategory;
      }
    }
    if (income) {
      int index = _incomeCategories.indexWhere(
          (category) => category.title == updatedCategory.title);
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


  // save category to userSavedCategoryMap
  void saveCategoryToMap(int id, String name) {
    _userSavedCategoryMap[id] = name;
    maps.put('userSavedCategoryMap', _userSavedCategoryMap);
    notifyListeners();
  }

  // get the category from userSavedCategoryMap by id and return the name

  String getCategoryNameById(int id) {
    return _userSavedCategoryMap[id] ?? '';
  }

  // find the category from expenseCategories or incomeCategories which matches category title

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


// {category:[messageids]}

  void getCategoryMap(BuildContext context) {
    _categoryMapExpense.clear();

    // initializing the categoryMap with all the categories
    for (var category in _expenseCategories) {
      _categoryMapExpense[category.title] = [];
    }

    for (var category in _incomeCategories) {
      _categoryMapIncome[category.title] = [];
    }

    // filling the categoryMap with messagesIds using userSavedCategoryMap
    _userSavedCategoryMap.forEach((key, value) {
      if(_categoryMapExpense.containsKey(value)){
        _categoryMapExpense[value]!.add(key);
      }

    _userSavedCategoryMap.forEach((key, value) {
      if(_categoryMapIncome.containsKey(value)){
        _categoryMapIncome[value]!.add(key);
      }
    });
    });

    notifyListeners();

  }


}

// i can get smsMessage from id
// i can get category from id
// i can extract money from smsMessage