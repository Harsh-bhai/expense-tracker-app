import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/budget_notifier.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';

class AnalysisNotifier extends ChangeNotifier {
  Map<String, double> _categoryWiseMoney = {};
  Map<String, double> get categoryWiseMoney => _categoryWiseMoney;
  set categoryWiseMoney(Map<String, double> value) {
    _categoryWiseMoney = value;
    notifyListeners();
  }

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

  Future<void> calculateCategoryWiseSpending(
      {required CategoryNotifier categoryNotifier,
      required BudgetNotifier budgetNotifier,
      required MoneyNotifier moneyNotifier,
      required BuildContext context}) async {
    totalMoney = moneyNotifier.debitMoney;
    knownCategoryExpense = 0;
    categoryWiseMoney.clear();

    // Initialize map
    for (var element in categoryNotifier.expenseCategories) {
      categoryWiseMoney[element.title] = 0;
    }
    for (var element in categoryNotifier.incomeCategories) {
      categoryWiseMoney[element.title] = 0;
    }

    categoryNotifier.getCategoryMap(context);

    categoryNotifier.categoryMapExpense.forEach((key, value) {
      HiveListTileModel? category =
          categoryNotifier.findCategory(key, isDebit: true);

      for (var id in value) {
        SmsMessage? message = moneyNotifier.getDebitMessageById(id);

        if (message == null ||
            (moneyNotifier.startDate != null &&
                message.date!.isBefore(moneyNotifier.startDate!)) ||
            (moneyNotifier.endDate != null &&
                message.date!.isAfter(moneyNotifier.endDate!))) {
          continue;
        }

        int amount =
            moneyNotifier.getMoneyFromRegex(moneyNotifier.moneyregex, message);

        categoryWiseMoney[category?.title ?? ""] =
            (categoryWiseMoney[category?.title ?? ""] ?? 0) + amount;

        knownCategoryExpense += amount;
      }
    });

    budgetNotifier.categorySpent = categoryWiseMoney;
    budgetNotifier.overallSpent = totalMoney.toDouble();
    isDataReady = true;
    await budgetNotifier.throwNotificationIfLimitExceeded();
    notifyListeners();
  }
}
