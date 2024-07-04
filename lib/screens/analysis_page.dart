import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:provider/provider.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int _touchedIndex = -1; // State variable to track the touched section index
  Map<String, int> categoryWiseMoney = {};
  int totalMoney = 0;
  int knownCategoryExpense = 0;
  
 

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<CommonNotifier>(context, listen: false).loadChartData();
    });
  }



  @override
  Widget build(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context);
    String startDate =
        commonNotifier.getMonthYear(moneyNotifier.startDate ?? DateTime.now());
    String endDate =
        commonNotifier.getMonthYear(moneyNotifier.endDate ?? DateTime.now());
    List<HiveListTileModel> categoryArray = [
      ...categoryNotifier.expenseCategories,
      HiveListTileModel(
        title: 'Unknown',
        bgColor: Colors.grey.shade300,
        icon: Icons.question_mark,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis'),
      ),
      body: categoryNotifier.userSavedCategoryMap.isNotEmpty
          ? SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                    child: Text(
                      "Category-Wise Analysis",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Card(
                    shadowColor: Colors.grey,
                    elevation: 10,
                    margin: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (startDate == endDate)
                              ?  const Text(
                                  "This Month",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : Text(
                                  "$startDate - $endDate",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          commonNotifier.isDataReady
                              ? AspectRatio(
                                  aspectRatio: 1.3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: PieChart(
                                      PieChartData(
                                        sections: _showingSections(
                                            context, _touchedIndex),
                                        centerSpaceRadius: 30,
                                        sectionsSpace: 1,
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                        ),
                                        pieTouchData: PieTouchData(
                                          touchCallback: (FlTouchEvent event,pieTouchResponse) {
                                            if (pieTouchResponse != null &&pieTouchResponse.touchedSection !=null) {
                                              setState(() {
                                                _touchedIndex = pieTouchResponse
                                                    .touchedSection!
                                                    .touchedSectionIndex;
                                              });
                                              print("object: ${pieTouchResponse
                                                    .touchedSection!
                                                    .touchedSectionIndex}");
                                            } else {
                                              setState(() {
                                                _touchedIndex = -1;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                height: MediaQuery.of(context).size.height * 0.35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                alignment: Alignment.center,
                                child: const Center(child: CircularProgressIndicator())),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categoryArray.length,
                              itemBuilder: (context, index) {
                                final category = categoryArray[index];
                                // bool isHighlighted = _touchedIndex == index;

                                return Container(
                                  decoration: BoxDecoration(
                                    color: 
                                    // isHighlighted
                                    //     ? category.bgColor
                                    //             ?.withOpacity(0.3) ??
                                    //         Colors.grey.shade300
                                    //             .withOpacity(0.3):
                                     Colors.transparent,
                                    borderRadius: BorderRadius.circular(40.0),
                                    border: Border.all(
                                      color: 
                                      // isHighlighted
                                      //     ? category.bgColor
                                      //             ?.withOpacity(1) ??
                                      //         Colors.grey.shade300
                                      //             .withOpacity(0.3):
                                                   Colors.transparent,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(category.title ?? "Unknown"),
                                    trailing: Text(
                                      "₹${categoryWiseMoney[category.title] ?? totalMoney - knownCategoryExpense}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 24.0,
                                      backgroundColor: category.bgColor,
                                      child: Icon(
                                        category.iconData,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : noDataFound(context),
    );
  }

  Center noDataFound(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "No data found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            const Icon(
              Icons.no_sim_outlined,
              size: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Add some categories to transactions to see analysis",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TransactionsPage()));
                },
                child: const Text("Go to Transactions"))
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(BuildContext context, int? touchedIndex) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    totalMoney = moneyNotifier.debitMoney;
    knownCategoryExpense = 0;

    categoryWiseMapInit(categoryNotifier, categoryWiseMoney);
    categoryNotifier.getCategoryMap(context);
    List<PieChartSectionData> sections = [];

    int index = 0; // Index tracker for sections
    try {
      categoryNotifier.categoryMapExpense.forEach((key, value) {
      HiveListTileModel? categoryName =
          categoryNotifier.findCategory(key, isDebit: true);

      for (var element in value) {
        print("key: $key, value: $value");
        SmsMessage? message = moneyNotifier.getDebitMessageById(element);
        if(message == null || message.date!.isBefore(moneyNotifier.startDate ?? DateTime.now()) && message.date!.isAfter(moneyNotifier.endDate ?? DateTime.now())) {
          continue;
        }
        int amount =
            moneyNotifier.getMoneyFromRegex(moneyNotifier.moneyregex, message);
        categoryWiseMoney[categoryName?.title ?? ""] =
            categoryWiseMoney[categoryName?.title ?? ""]! + amount;
        knownCategoryExpense = knownCategoryExpense + amount;
      }
      double percentage =
          (categoryWiseMoney[categoryName?.title ?? ""]! / totalMoney) * 100;

      // Check if this section is touched
      // bool isTouched = (index == touchedIndex); 
      double radius = 80; // Increase radius if touched
      double fontSize = 12; // Increase font size if touched

      PieChartSectionData section = PieChartSectionData(
        color: categoryName?.bgColor,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        borderSide:
        //  isTouched
        //     ? const BorderSide(color: Colors.black, width: 4):
             BorderSide(color: Colors.black.withOpacity(0)),
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );

      sections.add(section);
      index++;
    });

    
    double percentage =
        ((totalMoney - knownCategoryExpense) / totalMoney) * 100;
    PieChartSectionData unknownMoneySection = PieChartSectionData(
      color: Colors.grey.shade300,
      value: percentage,
      title: '${percentage.toStringAsFixed(0)}%',
      radius: 80,
      borderSide: 
      // touchedIndex == sections.length
      //     ? const BorderSide(color: Colors.black, width: 4):
           BorderSide(color: Colors.black.withOpacity(0)),
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
    sections.add(unknownMoneySection);
    print("index: $index");
    } catch (e) {
      print("error: $e");
    }
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
