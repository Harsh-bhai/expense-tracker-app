import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/screens/categories.dart';
import 'package:expense_tracker/screens/pie_chart.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  // List of settings options using ListTileModel
  final List<ListTileModel> settingsOptions = [
     const ListTileModel(
      title: 'Account',
      subtitle: 'Manage your account settings',
      icon: Icons.account_circle,
      page: CategoryPage(),
    ),
     const ListTileModel(
      title: 'Categories',
      subtitle: 'Manage your categories',
      icon: Icons.category,
      page: CategoryPage(),
    ),
     const ListTileModel(
      title: 'Privacy',
      subtitle: 'Adjust your privacy settings',
      icon: Icons.lock,
      page: CategoryPage(),
    ),
     const ListTileModel(
      title: 'Pie Chart',
      subtitle: 'Pie Chart',
      icon: Icons.language,
      page: PieChartPage(),
    ),
     const ListTileModel(
      title: 'Help',
      subtitle: 'Get help and support',
      icon: Icons.help,
      page: CategoryPage()    ),
     const ListTileModel(
      title: 'About',
      subtitle: 'Learn more about us',
      icon: Icons.info,
      page: CategoryPage()
    ),
     const ListTileModel(
      title: 'Log Out',
      subtitle: 'Sign out of your account',
      icon: Icons.exit_to_app,
      page: CategoryPage(),
    ),
    
  ];

   SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Settings'),
      ),
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          final option = settingsOptions[index];
          return ListTile(
            leading: Icon(option.icon),
            title: Text(option.title ?? ''),
            subtitle: Text(option.subtitle ?? ''),
            onTap: () {
              // Handle tap here, e.g., navigate to another page
              Navigator.push(context, MaterialPageRoute(builder: (context) => option.page!));
            },
          );
        },
      ),
    );
  }
}


