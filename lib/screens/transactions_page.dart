// ignore_for_file: avoid_print

import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/components/dropdown.dart';
import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/widgets.dart';
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
    CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context);

    return messages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              SmsMessage message = messages[index];
              String currentCategoryName =
                  categoryNotifier.getCategoryNameById(message.id ?? 0);
              HiveListTileModel? currentCategory =
                  categoryNotifier.findCategory(currentCategoryName,isDebit: isDebit);
                  print("currentCategoryName: $currentCategory");
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
                    onLongPress: () {
                      transactionDialog(context,
                          message: message, isDebit: isDebit);
                    },
                    leading:  CircleAvatar(
                      radius: 24.0,
                      backgroundColor: currentCategory?.bgColor ?? Colors.grey.shade300,
                      child: Icon(
                         currentCategory?.iconData ?? Icons.question_mark,
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
                          style: TextStyle(
                              fontSize: 9, color: Colors.grey.shade500),
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

  Future<dynamic> transactionDialog(BuildContext context,
      {required SmsMessage message, required bool isDebit}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Transaction Details"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.sender ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(message.body ?? ''),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Select Transaction Category",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyDropDown(
              isDebit: isDebit,
              message: message,
            ),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Date: ${formatDateTime(message.date ?? DateTime.now())[0]}",
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Time: ${formatDateTime(message.date ?? DateTime.now())[1]}",
              ),
            ),
          ],
        ),
        // content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
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
