import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/components/money_bubble.dart';
import 'package:expense_tracker/components/mybottom_bar.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/settings_page.dart';
import 'package:expense_tracker/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 28,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.menu,
            ),
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
      ),
      bottomNavigationBar: const MyBottomBar(),
      floatingActionButton: DatePickerButton(moneyNotifier: moneyNotifier),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "This Month",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MoneyBubble(
                color: Colors.red,
                icon: Icons.arrow_upward,
                title: "Spending",
                money: 0,
              ),
              MoneyBubble(
                color: Color.fromARGB(255, 75, 223, 80),
                icon: Icons.arrow_downward,
                title: "Income",
                money: 0,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              "Balance : ₹0.00",
            ),
          ),
          const SizedBox(height: 60,),
          Center(
            child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Transactions()));
            }, child: const Text("Transactions")),
          ),
        ],
      ),
    );
  }
}
