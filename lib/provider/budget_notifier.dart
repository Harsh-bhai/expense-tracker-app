import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class BudgetNotifier extends ChangeNotifier {
  double _overallLimit = 0;
  double _overallSpent = 0;

  final Map<String, double> _categoryLimits = {};
  final Map<String, double> _categorySpent = {};

  double get overallLimit => _overallLimit;
  Map<String, double> get categoryLimits => _categoryLimits;

  void setOverallLimit(double limit) {
    _overallLimit = limit;
    notifyListeners();
  }

  void setCategoryLimit(String category, double limit) {
    _categoryLimits[category] = limit;
    notifyListeners();
  }

  void updateSpending(double amount, String category) {
    _overallSpent += amount;
    _categorySpent[category] = (_categorySpent[category] ?? 0) + amount;
    _checkBudgetExceed(category);
    notifyListeners();
  }

  void _checkBudgetExceed(String category) {
    if (_overallSpent > _overallLimit && _overallLimit > 0) {
      _sendNotification(
        "Overall Budget Limit Exceeded",
        "Exceeded by ₹${(_overallSpent - _overallLimit).toStringAsFixed(2)}",
      );
    }

    if ((_categorySpent[category] ?? 0) > (_categoryLimits[category] ?? double.infinity)) {
      _sendNotification(
        "$category Budget Limit Exceeded",
        "Exceeded by ₹${((_categorySpent[category] ?? 0) - _categoryLimits[category]!).toStringAsFixed(2)}",
      );
    }
  }

  void _sendNotification(String title, String body) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        channelKey: 'budget_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
