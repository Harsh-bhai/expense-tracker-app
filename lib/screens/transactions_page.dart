// ignore_for_file: avoid_print

import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
          _buildMessagesListView(moneyNotifier.debitMessages),
          _buildMessagesListView(moneyNotifier.creditMessages),
        ],
      ),
    );
  }

  Widget _buildMessagesListView(List<SmsMessage> messages) {
    // print("addresrs : ${messages[0].address} id:  ${messages[0].id}");
    return messages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              SmsMessage message = messages[index];
              return Card(
                child: ListTile(
                  tileColor: Colors.grey.shade100,
                  title: Text(message.sender ?? 'Unknown'),
                  subtitle: Text(message.body ?? ''),
                ),
              );
            },
          );
  }
}

