import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/components/money_bubble.dart';
import 'package:expense_tracker/components/mybottom_bar.dart';
import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/analysis_page.dart';
import 'package:expense_tracker/screens/budget_page.dart';
import 'package:expense_tracker/screens/categories_page.dart';
import 'package:expense_tracker/screens/settings_page.dart';
import 'package:expense_tracker/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ListTileModel> options = [
      ListTileModel(
          title: 'Transactions',
          subtitle: 'View your Transactions history',
          icon: Icons.history,
          page: const Transactions(),
          iconColor: Colors.orange),
      ListTileModel(
          title: 'Analysis',
          subtitle: 'View your spending summary',
          icon: Icons.auto_graph,
          page: const AnalysisPage(),
          iconColor: Colors.blue),
      ListTileModel(
          title: 'Set Budget',
          subtitle: 'Set budget limit on categories',
          icon: Icons.monetization_on,
          page: const BudgetPage(),
          iconColor: Colors.green),
      ListTileModel(
          title: 'Categories',
          subtitle: 'Manage your Expense and Income categories',
          icon: Icons.category,
          page: const CategoryPage(),
          iconColor: Colors.yellow),
    ];
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Hi, Guest'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              size: 26,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: DatePickerButton(moneyNotifier: moneyNotifier),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Text(
              "This Month",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MoneyBubble(
                color: Colors.red,
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
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Balance : ₹${moneyNotifier.creditMoney - moneyNotifier.debitMoney}",style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            indent: 20.0,
            endIndent: 20.0,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(options[index].title ?? ''),
                  subtitle: Text(options[index].subtitle ?? '',style:  TextStyle(fontSize: 13,color: Colors.grey.shade600),),
                  leading:
                      Icon(options[index].icon, color: options[index].iconColor,size: 40,),
                      trailing: const Icon(Icons.chevron_right_sharp,size: 30,),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            options[index].page ?? const HomePage(),
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
