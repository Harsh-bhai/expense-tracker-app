import 'package:expense_tracker/components/money_bubble.dart';
import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/provider/bank_notifier.dart';
import 'package:expense_tracker/provider/budget_notifier.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/about_page.dart';
import 'package:expense_tracker/screens/budget_page.dart';
import 'package:expense_tracker/screens/notifications_page.dart';
import 'package:expense_tracker/screens/settings_page.dart';
import 'package:expense_tracker/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Delayed init to avoid context errors
    Future.delayed(Duration.zero, () {
      if (!_isInitialized && mounted) {
        initNotifiers(context);
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  void initNotifiers(BuildContext context) {
    final moneyNotifier = Provider.of<MoneyNotifier>(context, listen: false);
    final bankNotifier = Provider.of<BankNotifier>(context, listen: false);
    final categoryNotifier = Provider.of<CategoryNotifier>(context, listen: false);
    final budgetNotifier = Provider.of<BudgetNotifier>(context, listen: false);

    // Setup configs
    bankNotifier.getBank();
    categoryNotifier.getCategories();
    budgetNotifier.getBudgets(); // This sets _overallLimit and notifies
    moneyNotifier.getSmsMessages(bankNotifier);

    // Regex setup
    moneyNotifier.debitregex = bankNotifier.selectedBank?.debitRegex;
    moneyNotifier.creditregex = bankNotifier.selectedBank?.creditRegex;
    moneyNotifier.moneyregex = bankNotifier.selectedBank?.moneyRegex;
  }

  @override
  Widget build(BuildContext context) {
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context);
    String startDate = commonNotifier.getMonthYear(moneyNotifier.startDate ?? DateTime.now());
    String endDate = commonNotifier.getMonthYear(moneyNotifier.endDate ?? DateTime.now());
    int money = moneyNotifier.creditMoney - moneyNotifier.debitMoney;

    final List<ListTileModel> options = [
      ListTileModel(
          title: 'Transactions',
          subtitle: 'View your Transactions history',
          icon: Icons.history,
          page: const TransactionsPage(),
          iconColor: Colors.orange),
      ListTileModel(
          title: 'Reminder',
          subtitle: 'Set Reminder to add category to transactions',
          icon: Icons.notification_add,
          page: const NotificationsPage(),
          iconColor: Colors.yellow.shade600),
      ListTileModel(
          title: 'Set Budget',
          subtitle: 'Set budget limit on categories',
          icon: Icons.monetization_on,
          page: const BudgetPage(),
          iconColor: Colors.green),
      ListTileModel(
          title: 'About Us',
          subtitle: 'Learn more about us',
          icon: Icons.info,
          page: const AboutPage(),
          iconColor: Colors.blue),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Hi, Guest'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            ),
          ),
          const SizedBox(width: 15)
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: (startDate == endDate)
                ? const Text("This Month", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))
                : Text("$startDate - $endDate", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MoneyBubble(
                color: Colors.orange.shade700,
                icon: Icons.arrow_upward,
                title: "Spending",
                money: moneyNotifier.debitMoney,
              ),
              MoneyBubble(
                color: const Color.fromARGB(255, 75, 223, 80),
                icon: Icons.arrow_downward,
                title: "Income",
                money: moneyNotifier.creditMoney,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: money > 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Net : ₹$money",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(indent: 20.0, endIndent: 20.0),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(options[index].title ?? ''),
                  subtitle: Text(
                    options[index].subtitle ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  leading: Icon(options[index].icon, color: options[index].iconColor, size: 40),
                  trailing: const Icon(Icons.chevron_right_sharp, size: 30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => options[index].page ?? const HomePage(),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
