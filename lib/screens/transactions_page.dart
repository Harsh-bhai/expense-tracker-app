// ignore_for_file: avoid_print

import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Debit'),
            Tab(text: 'Credit'),
          ],
        ),
      ),
      floatingActionButton: DatePickerButton(moneyNotifier: moneyNotifier),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesListView(moneyNotifier.debitMessages, isDebit: true),
          _buildMessagesListView(moneyNotifier.creditMessages, isDebit: false),
        ],
      ),
    );
  }

  Widget _buildMessagesListView(List<SmsMessage> messages,
      {bool isDebit = true}) {
    MoneyNotifier moneyNotifier =
        Provider.of<MoneyNotifier>(context, listen: false);
    return messages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              SmsMessage message = messages[index];
              Match? moneyMatch = moneyNotifier.moneyregex.firstMatch(
                  message.body!.toLowerCase().replaceFirst(",", ""));
              if (moneyMatch != null) {
                int amount = int.parse(moneyMatch.group(1)!);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(800),
                  ),
                  elevation: 0,
                  child: ListTile(
                    tileColor: Colors.grey.shade100,
                    leading: const CircleAvatar(
                      radius: 24.0,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatDateTime(message.date ?? DateTime.now())[0],
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          formatDateTime(message.date ?? DateTime.now())[1],
                          style:  TextStyle(fontSize: 9,color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    title: isDebit
                        ? Text(
                            "- ₹$amount.00",
                            style: const TextStyle(color: Colors.red),
                          )
                        : Text(
                            "+ ₹$amount.00",
                            style: const TextStyle(color: Colors.green),
                          ),
                    // subtitle: Text(message.body ?? ''),
                  ),
                );
              }
              return null;
            },
          );
  }
}


List<String> formatDateTime(DateTime dateTime) {
  // Format the date as "day monthname year"
  String formattedDate = DateFormat('d MMM yy').format(dateTime);

  // Format the time as "hour:minute AM/PM"
  String formattedTime = DateFormat('h:mm a').format(dateTime);

  // Return the formatted date and time as a list
  return [formattedDate, formattedTime];
}