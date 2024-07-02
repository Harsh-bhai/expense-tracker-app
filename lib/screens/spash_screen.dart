import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

  _navigateToHome() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    MoneyNotifier moneyNotifier =
        Provider.of<MoneyNotifier>(context, listen: false);
    CommonNotifier commonNotifier =
        Provider.of<CommonNotifier>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
      MaterialPageRoute(
          builder: (context) => refreshWrapper(moneyNotifier, commonNotifier,
              const LandingPage())), // Change to your main screen
    );
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',
                height: 200), // Your logo asset
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

RefreshIndicator refreshWrapper(
    MoneyNotifier moneyNotifier, CommonNotifier commonNotifier, Widget child) {
  return RefreshIndicator(
    color: Colors.deepPurple,
    backgroundColor: Colors.white,
    strokeWidth: 2,
    triggerMode: RefreshIndicatorTriggerMode.onEdge,
    displacement: 100,
    edgeOffset: 20,
    onRefresh: () => moneyNotifier.refreshDates(commonNotifier),
    child: child,
  );
}
