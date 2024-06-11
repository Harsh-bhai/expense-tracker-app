import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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
    Provider.of<MoneyNotifier>(context, listen: false).getSmsMessages();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Debit'),
            Tab(text: 'Credit'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setterState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text("Start Date"),
                        leading: const Icon(Icons.date_range),
                        trailing: moneyNotifier.startDate != null
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        onTap: () {
                          moneyNotifier.selectStartDate(context, setterState);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("End Date"),
                        leading: const Icon(Icons.date_range),
                        trailing: moneyNotifier.endDate != null
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                        onTap: () {
                          moneyNotifier.selectEndDate(context, setterState);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
          );
        },
        child: const Icon(Icons.filter_alt),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMessagesListView(moneyNotifier.Debitmessages),
          _buildMessagesListView(moneyNotifier.Creditmessages),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesListView(List<SmsMessage> messages) {
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
