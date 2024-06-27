import 'package:expense_tracker/components/date_picker_button.dart';
import 'package:expense_tracker/components/mybottom_bar.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    return Scaffold(
      bottomNavigationBar: const MyBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: DatePickerButton(moneyNotifier: moneyNotifier),
      body: commonNotifier.screens[commonNotifier.selectedIndex],
    );
  }
}
