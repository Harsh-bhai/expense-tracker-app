import 'package:expense_tracker/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()), // Change to your main screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 200), // Your logo asset
            const SizedBox(height: 20),
             Text(
              'Expense Tracker',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: colorFromHex("#e8a81e"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
