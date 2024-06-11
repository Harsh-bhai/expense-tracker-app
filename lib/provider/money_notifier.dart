// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MoneyNotifier extends ChangeNotifier {
  List<SmsMessage> _Debitmessages = [];
  List<SmsMessage> _Creditmessages = [];

  DateTime? _startDate;
  DateTime? _endDate;

  final SmsQuery _query = SmsQuery();

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  List<SmsMessage> get Debitmessages => _Debitmessages;
  List<SmsMessage> get Creditmessages => _Creditmessages;

  Future<void> getSmsMessages() async {
    // Check and request permission if needed
    var permission = await Permission.sms.status;
    if (!permission.isGranted) {
      permission = await Permission.sms.request();
      if (!permission.isGranted) {
        return;
      }
    }

    // Fetch SMS messages
    List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox],
    );

    // Use the selected start and end dates for filtering
    DateTime now = DateTime.now();
    DateTime startDate = _startDate ?? DateTime(now.year, now.month, 1);
    DateTime endDate =
        _endDate ?? DateTime(startDate.year, startDate.month + 1, 0);

    // Filter messages
    List<SmsMessage> debitmessages = messages.where((message) {
      DateTime? messageDate = message.date;
      return message.body != null &&
          message.sender != null &&
          message.sender!.contains("-BOBSMS") &&
          message.body!.toLowerCase().contains(".00 debited from a/c") &&
          messageDate != null &&
          messageDate.isAfter(startDate) &&
          messageDate.isBefore(endDate);
    }).toList();

    List<SmsMessage> creditmessages = messages.where((message) {
      DateTime? messageDate = message.date;
      return message.body != null &&
          message.sender != null &&
          message.sender!.contains("-BOBTXN") &&
          message.body!.toLowerCase().contains("credited to a/c") &&
          messageDate != null &&
          messageDate.isAfter(startDate) &&
          messageDate.isBefore(endDate);
    }).toList();

    // Update the state with fetched messages
    _Debitmessages = debitmessages;
    _Creditmessages = creditmessages;
    notifyListeners();
  }

  Future<void> selectStartDate(
      BuildContext context, StateSetter setterState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      _startDate = picked;
      setterState(() {}); // Refresh the dialog state
      getSmsMessages(); // Refresh messages with the new selected date
    }
  }

  Future<void> selectEndDate(
      BuildContext context, StateSetter setterState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      _endDate = picked;
      setterState(() {}); // Refresh the dialog state
      getSmsMessages(); // Refresh messages with the new selected date
    }
  }
}
