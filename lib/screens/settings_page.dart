import 'package:expense_tracker/models/listtile_model.dart';
import 'package:expense_tracker/screens/about_page.dart';
import 'package:expense_tracker/screens/categories_page.dart';
import 'package:expense_tracker/screens/home_page.dart';
import 'package:flutter/material.dart';

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
      title: 'Privacy',
      subtitle: 'Adjust your privacy settings',
      icon: Icons.lock,
      page: const AboutPage(),
    ),
     ListTileModel(
      title: 'About',
      subtitle: 'Learn more about us',
      icon: Icons.info,
      page: const AboutPage()
    ),
     ListTileModel(
      title: 'Notifications',
      subtitle: 'Set up notifications',
      icon: Icons.notification_add,
      page: const AboutPage()
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


