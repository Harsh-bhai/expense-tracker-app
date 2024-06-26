import 'package:expense_tracker/components/indicator.dart';
import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int _touchedIndex = -1; // State variable to track the touched section index

  @override
  Widget build(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    List<HiveListTileModel> categoryArray = [...categoryNotifier.expenseCategories,
    //FIXME - add unknown category
    // HiveListTileModel(
    //   title: 'Unknown',
    //   bgColor: Colors.grey.shade300,
    //   icon: Icons.question_mark,
    // )
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: _showingSections(
                      context, _touchedIndex), // Pass the touched index
                  centerSpaceRadius: 40,
                  sectionsSpace: 1,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (pieTouchResponse != null &&
                          pieTouchResponse.touchedSection != null) {
                        setState(() {
                          _touchedIndex = pieTouchResponse.touchedSection!
                              .touchedSectionIndex; // Update touched index
                        });
                      } else {
                        setState(() {
                          _touchedIndex =
                              -1; // Reset touched index if no section is touched
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),

          // category labels
            Expanded(
            child: Wrap(
              children: List.generate(
                categoryArray.length,
                (index) {
                  final category = categoryNotifier.expenseCategories[index];
                  bool isHighlighted = _touchedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Indicator(
                      color:  category.bgColor,
                      icon: category.iconData,
                      text: category.title,
                      showBorder: isHighlighted,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
      BuildContext context, int? touchedIndex) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    int totalMoney = moneyNotifier.debitMoney;
    int currentTotalExpense = 0;

    Map<String, int> categoryWiseMoney = {};
    categoryWiseMapInit(categoryNotifier, categoryWiseMoney);
    categoryNotifier.getCategoryMap(context);
    List<PieChartSectionData> sections = [];

    int index = 0; // Index tracker for sections
    categoryNotifier.categoryMapExpense.forEach((key, value) {
      HiveListTileModel? categoryName =
          categoryNotifier.findCategory(key, isDebit: true);

      for (var element in value) {
        SmsMessage? message = moneyNotifier.getDebitMessageById(element);
        int amount =
            moneyNotifier.getMoneyFromRegex(moneyNotifier.moneyregex, message!);
        categoryWiseMoney[categoryName?.title ?? ""] =
            categoryWiseMoney[categoryName?.title ?? ""]! + amount;
        currentTotalExpense = currentTotalExpense + amount;
      }
      double percentage =
          (categoryWiseMoney[categoryName?.title ?? ""]! / totalMoney) * 100;

      bool isTouched =
          index == touchedIndex; // Check if this section is touched
      double radius = 80; // Increase radius if touched
      double fontSize = 12; // Increase font size if touched

      PieChartSectionData section = PieChartSectionData(
        color: categoryName?.bgColor,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        borderSide: isTouched
            ? const BorderSide(color: Colors.black, width: 4)
            : BorderSide(color: Colors.black.withOpacity(0)),
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

      sections.add(section);
      index++;
    });

    double percentage = ((totalMoney - currentTotalExpense) / totalMoney) * 100;
    PieChartSectionData unknownMoneySection = PieChartSectionData(
      color: Colors.grey.shade300,
      value: percentage,
      title: '${percentage.toStringAsFixed(0)}%',
      radius: 80,
      borderSide: touchedIndex == sections.length
          ? const BorderSide(color: Colors.black, width: 4)
          : BorderSide(color: Colors.black.withOpacity(0)),
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
    sections.add(unknownMoneySection);
    return sections;
  }

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
