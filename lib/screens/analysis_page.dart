import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: _showingSections(context),
                  centerSpaceRadius: 40,
                  sectionsSpace: 1,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Handle touch event if needed

                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    int totalMoney = moneyNotifier.debitMoney;
    int currentTotalExpense = 0;

    // to store category wise money expenditure
    Map<String, int> categoryWiseMoney = {};
    categoryWiseMapInit(categoryNotifier, categoryWiseMoney);
    categoryNotifier.getCategoryMap(context);
    List<PieChartSectionData> sections = [];

    // iterating through each category wise array containing message ids
    categoryNotifier.categoryMapExpense.forEach((key, value) {
      HiveListTileModel? categoryName = categoryNotifier.findCategory(key, isDebit: true);

      // iterating through each message id and extracting the amount
      for (var element in value) {
        SmsMessage? message = moneyNotifier.getDebitMessageById(element);
        int amount = moneyNotifier.getMoneyFromRegex(moneyNotifier.moneyregex, message!);
        categoryWiseMoney[categoryName?.title ?? ""] = categoryWiseMoney[categoryName?.title ?? ""]! + amount;
        currentTotalExpense = currentTotalExpense + amount;
      }
      double percentage = (categoryWiseMoney[categoryName?.title ?? ""]! / totalMoney) * 100;

      // creating pie chart section for category
      PieChartSectionData section = PieChartSectionData(
        color: categoryName?.bgColor,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
      sections.add(section);
    });

    // unknown category money expenditure
    double percentage = ( (totalMoney - currentTotalExpense) / totalMoney) * 100;
    PieChartSectionData unknownMoneySection =PieChartSectionData(
        color: Colors.grey.shade300,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    sections.add(unknownMoneySection);
    return sections;
  }

  // initializing all category keys to 0
  void categoryWiseMapInit(
      CategoryNotifier categoryNotifier, Map<String, int> categoryWiseMoney) {
    for (var element in categoryNotifier.expenseCategories) {
      categoryWiseMoney[element.title] = 0;
    }
    for (var element in categoryNotifier.incomeCategories) {
      categoryWiseMoney[element.title] = 0;
    }
  }
}
