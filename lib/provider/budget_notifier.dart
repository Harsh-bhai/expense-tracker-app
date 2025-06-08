import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class BudgetNotifier extends ChangeNotifier {
  double _overallLimit = 0;
  double _overallSpent = 0;
  double get overallSpent => _overallSpent;
  set overallSpent(double value) {
    _overallSpent = value;
    notifyListeners();
  }

  double get overallLimit => _overallLimit;
  Map<String, double> get categoryLimits => _categoryLimits;

  // so that we don't notify multiple times
  // bool _overallLimit = false;
  // final Map<String, double> _categoryWiseLimitNotified = {};

  final Map<String, double> _categoryLimits = {};
  final Map<String, double> _categorySpent = {};
  Map<String, double> get categorySpent => _categorySpent;
  set categorySpent(Map<String, double> value) {
    _categorySpent.clear();
    _categorySpent.addAll(value);
    notifyListeners();
  }

  void setOverallLimit(double limit) {
    var budgetBox = Hive.box('budget');
    var notificationBox = Hive.box('notification');
    _overallLimit = limit;
    budgetBox.put('overallBudget', limit.toInt());
    notificationBox.put('overallLimit', false);
    notifyListeners();
  }

  void setCategoryLimit(String category, double limit) {
    var budgetBox = Hive.box('budget');
    var notificationBox = Hive.box('notification');
    _categoryLimits[category] = limit;
    budgetBox.put(category, limit);
    notificationBox.put(category, false);
    notifyListeners();
  }

  Future<void> throwNotificationIfLimitExceeded() async {
    // check if overall limit exceeded
    await _checkOverallBudgetExceed();
    // check if category wise limit exceeded
    _categorySpent.forEach((category, amount) async => 
        await _checkCategoryWiseBudgetExceed(category)
      );
    notifyListeners();
  }

  Future<void> _checkOverallBudgetExceed() async {
    var notificationBox = Hive.box('notification');
    bool overallLimitNotification = notificationBox.get('overallLimit', defaultValue: false);
    if (_overallSpent > _overallLimit && _overallLimit > 0 && !overallLimitNotification) {
      await _sendNotification(
        "Overall Budget Limit Exceeded",
        "Exceeded by ₹${(_overallSpent - _overallLimit).toStringAsFixed(2)}",
      );
      notificationBox.put('overallLimit', true); // notified once
    }


  }
  Future<void> _checkCategoryWiseBudgetExceed(String category) async {
    var notificationBox = Hive.box('notification');
    bool categoryLimitNotification = notificationBox.get(category, defaultValue: false);
        if ((_categorySpent[category] ?? 0) >
        (_categoryLimits[category] ?? double.infinity)  && !categoryLimitNotification) {
      await _sendNotification(
        "$category Budget Limit Exceeded",
        "Exceeded by ₹${((_categorySpent[category] ?? 0) - _categoryLimits[category]!).toStringAsFixed(2)}",
      );
      notificationBox.put(category, true); 
    }



  }

  Future<void> _sendNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        channelKey: 'budget_channel',
        title: title,
        body: body,
        category: NotificationCategory.Message,
        notificationLayout: NotificationLayout.Default,
        displayOnForeground: true,
        displayOnBackground: true,
      ),
    );
  }

  void getBudgets() {
    var budgetBox = Hive.box('budget');
    int overallBudget = budgetBox.get('overallBudget', defaultValue: 0);
    _overallLimit = overallBudget.toDouble();
    _categoryLimits.forEach((category, value) {
      _categoryLimits[category] = budgetBox.get(category, defaultValue: 0).toDouble();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
