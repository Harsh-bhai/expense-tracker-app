import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/provider/bank_notifier.dart';
import 'package:expense_tracker/screens/about_page.dart';
import 'package:expense_tracker/screens/budget_page.dart';
import 'package:expense_tracker/screens/categories_page.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:expense_tracker/screens/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  // List of settings options using ListTileModel
  final List<ListTileModel> settingsOptions = [
    ListTileModel(
      title: 'Categories',
      subtitle: 'Manage your categories',
      icon: Icons.category,
      page: const CategoryPage(),
    ),
    ListTileModel(
      title: 'Theme',
      subtitle: 'Select your preferred theme',
      icon: Icons.sunny,
      page: const AboutPage(),
    ),
    ListTileModel(
      title: 'Budget',
      subtitle: 'Set your budget limits',
      icon: Icons.monetization_on,
      page: const BudgetPage(),
    ),
    ListTileModel(
        title: 'About',
        subtitle: 'Learn more about us',
        icon: Icons.info,
        page: const AboutPage()),
    ListTileModel(
        title: 'Notifications',
        subtitle: 'Set up notifications',
        icon: Icons.notification_add,
        page: const NotificationsPage()),
  ];

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final banknotifier = Provider.of<BankNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: banknotifier.selectedBank != null
                ? bankIcon(banknotifier)
                : const CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.account_balance),
                  ),
            title: Text(
              banknotifier.selectedBank?.bankName ?? 'Select Bank',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            onTap: () async =>
                await banknotifier.showBankSelectionDialog(context),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: settingsOptions.length,
              itemBuilder: (context, index) {
                final option = settingsOptions[index];
                return ListTile(
                  leading: Icon(option.icon),
                  title: Text(option.title ?? ''),
                  subtitle: Text(option.subtitle ?? ''),
                  onTap: () {
                    // Handle tap here, e.g., navigate to another page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => option.page!));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container bankIcon(BankNotifier banknotifier) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: banknotifier.selectedBank!.image,
        ),
      ),
    );
  }
}

