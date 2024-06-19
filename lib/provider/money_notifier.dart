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

  Future<void> getSmsMessages() async {
    final permission = await Permission.sms.request();
    if (permission.isGranted) {
      final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);
      final startDate = _startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
      final endDate = _endDate ?? DateTime.now();
      _debitMessages.clear();
      _creditMessages.clear();
      for (final message in messages) {
        final messageDate = message.date;
        if (message.body != null &&
            message.sender != null &&
            (message.sender!.contains("-BOBSMS") &&
                message.body!.toLowerCase().contains(".00 debited from a/c")) ||
            (message.sender!.contains("-BOBTXN") &&
                message.body!.toLowerCase().contains("credited to a/c"))) {
          if (messageDate != null &&
              messageDate.isAfter(startDate) &&
              messageDate.isBefore(endDate)) {
            if (message.sender!.contains("-BOBSMS")) {
              _debitMessages.add(message);
            } else {
              _creditMessages.add(message);
            }
          }
        }
      }
      notifyListeners();
    }
  }

  bool isStartDateLoading = false;
  Future<void> selectStartDateWithProgressIndicator(BuildContext context, StateSetter setterState) async {
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
  Future<void> selectEndDateWithProgressIndicator(BuildContext context, StateSetter setterState) async {
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
}

