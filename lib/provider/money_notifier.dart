// ignore_for_file: non_constant_identifier_names

import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MoneyNotifier extends ChangeNotifier {
  final SmsQuery _query = SmsQuery();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<SmsMessage> _debitMessages = [];
  final List<SmsMessage> _creditMessages = [];
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<SmsMessage> get debitMessages => _debitMessages;
  List<SmsMessage> get creditMessages => _creditMessages;
  RegExp debitregex = RegExp(r"\b(debited | transferred)\s*\w+\s*a\/c\b");
  RegExp creditregex = RegExp(r"\b(credited)\s*\w+\s*a\/c\b");
  RegExp moneyregex = RegExp(r"rs\s*\.?\s*(\d+)(?:\.00|\s|\w+)");
  int debitMoney = 0;
  int creditMoney = 0;
  bool isMessagesLoading = false;
  final Map<DateTime, List<MapEntry<int, DateTime>>> _sameDayMoney = {};


Future<void> getSmsMessages() async {
  isMessagesLoading = true;
  creditMoney = 0;
  debitMoney = 0;
  final permission = await Permission.sms.request();
  if (permission.isGranted) {
    final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);
    final startDate = _startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
    final endDate = _endDate ?? DateTime.now();
    _debitMessages.clear();
    _creditMessages.clear();
    _sameDayMoney.clear();

    for (final message in messages) {
      final messageDate = message.date;
      if (messageDate != null &&
          messageDate.isAfter(startDate) &&
          messageDate.isBefore(endDate)) {

        // Get the date part of the message date
        final messageDay = DateTime(messageDate.year, messageDate.month, messageDate.day);

        // If the day has changed, clear the _sameDayMoney set
        if (!_sameDayMoney.containsKey(messageDay)) {
          _sameDayMoney[messageDay] = <MapEntry<int, DateTime>>[];
        }

        // Edge cases
        if (message.body != null && message.sender != null) {

          // Get debit messages
          if ((message.sender!.contains("-BOBSMS") || message.sender!.contains("-BOBTXN")) &&
              debitregex.hasMatch(message.body!.toLowerCase())) {

            // Extract money from message
            Match? moneyMatch = moneyregex.firstMatch(message.body!.toLowerCase().replaceFirst(",", ""));
            if (moneyMatch != null) {
              int amount = int.parse(moneyMatch.group(1)!);
              bool withinTwoHours = false;

              // Check if any transaction within 6 hours has the same amount
              for (final entry in _sameDayMoney[messageDay]!) {
                if (entry.key == amount && messageDate.difference(entry.value).inHours < 2) {
                  withinTwoHours = true;
                  break;
                }
              }

              if (!withinTwoHours) {
                debitMoney += amount;
                _debitMessages.add(message);
                _sameDayMoney[messageDay]!.add(MapEntry(amount, messageDate));
              }
            }
          }

          // Get credited money
          if (message.sender!.contains("-BOBTXN") &&
              creditregex.hasMatch(message.body!.toLowerCase())) {
            // Try to find a match in the message body
            Match? moneyMatch = moneyregex.firstMatch(message.body!.toLowerCase().replaceFirst(",", ""));
            // Extract and parse the amount from the match
            if (moneyMatch != null) {
              int amount = int.parse(moneyMatch.group(1)!);
              creditMoney += amount;
              _creditMessages.add(message);
            }
          }
        }
      }
    }
    notifyListeners();
    isMessagesLoading = false;
  }
}

  bool isStartDateLoading = false;
  Future<void> selectStartDate(
      BuildContext context, StateSetter setterState) async {
    isStartDateLoading = true;
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: _endDate ?? DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      _startDate = picked;
      setterState(() {});
      await getSmsMessages();
    }
    isStartDateLoading = false;
    notifyListeners();
  }

  bool isEndDateLoading = false;
  Future<void> selectEndDate(
      BuildContext context, StateSetter setterState) async {
    isEndDateLoading = true;
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      _endDate = picked;
      setterState(() {});
      await getSmsMessages();
    }
    isEndDateLoading = false;
    notifyListeners();
  }

//  get debit single smsmessage by message id
  SmsMessage? getDebitMessageById(int id) {
    return _debitMessages.firstWhere((message) => message.id == id);
  }

  int getMoneyFromRegex(RegExp regex, SmsMessage message) {
    int amount = 0;
    Match? moneyMatch =
        regex.firstMatch(message.body!.toLowerCase().replaceFirst(",", ""));
    // Extract and parse the amount from the match
    if (moneyMatch != null) {
      amount = int.parse(moneyMatch.group(1)!);
    }
    return amount;
  }
  
  Future<void> refreshDates(CommonNotifier commonNotifier) async {
    commonNotifier.isDataReady = false;
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _endDate = DateTime.now();
    await getSmsMessages();
    commonNotifier.loadChartData();
    notifyListeners();
    
  }

}
