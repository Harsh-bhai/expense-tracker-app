// ignore_for_file: non_constant_identifier_names

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



  Future<void> getSmsMessages() async {
    isMessagesLoading = true;
    creditMoney = 0;
    debitMoney = 0;
    final permission = await Permission.sms.request();
    if (permission.isGranted) {
      final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);
      final startDate =
          _startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
      final endDate = _endDate ?? DateTime.now();
      _debitMessages.clear();
      _creditMessages.clear();
      for (final message in messages) {
        final messageDate = message.date;
        if (message.body != null &&
                message.sender != null &&
                ((message.sender!.contains("-BOBSMS") || message.sender!.contains("-BOBTXN")) &&
                    debitregex.hasMatch(message.body!.toLowerCase())) ||
            (message.sender!.contains("-BOBTXN") &&
                creditregex.hasMatch(message.body!.toLowerCase()))) {
          if (messageDate != null &&
              messageDate.isAfter(startDate) &&
              messageDate.isBefore(endDate)) {
            if (message.sender!.contains("-BOBSMS") || message.sender!.contains("-BOBTXN")) {
              // Try to find a match in the message body
              Match? moneyMatch = moneyregex.firstMatch(
                  message.body!.toLowerCase().replaceFirst(",", ""));
              if (moneyMatch != null) {
                int amount = int.parse(moneyMatch.group(1)!);
                debitMoney +=
                    amount; // Assuming debitMoney is a double for precision
                _debitMessages.add(message);
              }
            } if (message.sender!.contains("-BOBTXN") &&
                    creditregex.hasMatch(message.body!.toLowerCase())) {
              // Try to find a match in the message body
              Match? moneyMatch = moneyregex.firstMatch(
                  message.body!.toLowerCase().replaceFirst(",", ""));
              // Extract and parse the amount from the match
              int amount = int.parse(moneyMatch!.group(1)!);
              creditMoney +=
                  amount; // Assuming creditMoney is a double for precision
              _creditMessages.add(message);
            }
          }
        }
      }
      notifyListeners();
      isMessagesLoading = false;
    }
  }

  bool isStartDateLoading = false;
  Future<void> selectStartDateWithProgressIndicator(
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
  Future<void> selectEndDateWithProgressIndicator(
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

// crete a method to get debit single smsmessage by message id

  SmsMessage? getDebitMessageById(int id) {
    return _debitMessages.firstWhere((message) => message.id == id);
  }

  int getMoneyFromRegex(RegExp regex, SmsMessage message) {
    int amount=0;
    Match? moneyMatch = regex.firstMatch(message.body!.toLowerCase().replaceFirst(",", ""));
    // Extract and parse the amount from the match
    if (moneyMatch != null) {
    amount = int.parse(moneyMatch.group(1)!);
    }
    return amount;
  }

  
  
}
