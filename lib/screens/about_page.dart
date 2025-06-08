import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                height: 100, // Adjust size as needed
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Expense Tracker',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'This application helps you keep track of your Expenses and Income. '
              'You can manage your daily expenses and identify unnecessary spending.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Key Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'Track Expenses & Income'),
            BulletPoint(text: 'Fetch data from Bank SMS automatically'),
            BulletPoint(text: 'Manage daily spending easily'),
            BulletPoint(
                text: 'Set Budget limits and reminders to avoid over spending'),
            BulletPoint(text: 'Identify unnecessary expenses'),
            SizedBox(height: 20),
            Text(
              'Supported Banks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            BulletPoint(text: 'Bank of Baroda (BOB)'),
            BulletPoint(text: 'State Bank of India (SBI)'),
            BulletPoint(text: 'United Commercial Bank (UCO)'),
            Text(
              'and more to come...',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
