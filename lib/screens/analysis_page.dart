import 'package:expense_tracker/components/analysis_expansion_tile.dart';
import 'package:expense_tracker/models/hive_listtile_model.dart';
import 'package:expense_tracker/provider/analysis_notifier.dart';
import 'package:expense_tracker/provider/category_notifier.dart';
import 'package:expense_tracker/provider/common_notifier.dart';
import 'package:expense_tracker/provider/money_notifier.dart';
import 'package:expense_tracker/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      Provider.of<AnalysisNotifier>(context, listen: false).loadChartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    CommonNotifier commonNotifier = Provider.of<CommonNotifier>(context);
    AnalysisNotifier analysisNotifier = Provider.of<AnalysisNotifier>(context);

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
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (startDate == endDate)
                              ? const Text(
                                  "This Month",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              : Text(
                                  "$startDate - $endDate",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),

                          /// Pie Chart Expansion Tile
                          AnalysisExpansionTile(
                            title: "Pie Chart",
                            initiallyExpanded: false,
                            child: Column(
                              children: [
                                analysisNotifier.isDataReady
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
                                                    color: Colors.black,
                                                    width: 1),
                                              ),
                                              pieTouchData: PieTouchData(
                                                touchCallback:
                                                    (event, pieTouchResponse) {
                                                  if (pieTouchResponse !=
                                                          null &&
                                                      pieTouchResponse
                                                              .touchedSection !=
                                                          null) {
                                                    setState(() {
                                                      _touchedIndex =
                                                          pieTouchResponse
                                                              .touchedSection!
                                                              .touchedSectionIndex;
                                                    });
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
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        child: const Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: categoryArray.length,
                                  itemBuilder: (context, index) {
                                    final category = categoryArray[index];
                                    return ListTile(
                                      title: Text(category.title ?? "Unknown"),
                                      trailing: Text(
                                        "₹${analysisNotifier.categoryWiseMoney[category.title] ?? analysisNotifier.totalMoney - analysisNotifier.knownCategoryExpense}",
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
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          /// Bar Graph Expansion Tile
                          const AnalysisExpansionTile(
                            title: "Bar Graph",
                            child: SizedBox(
                              height: 300,
                              child: Center(
                                child: Text(
                                  "Bar Graph coming soon...",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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

  List<PieChartSectionData> _showingSections(
      BuildContext context, int? touchedIndex) {
    CategoryNotifier categoryNotifier = Provider.of<CategoryNotifier>(context);
    MoneyNotifier moneyNotifier = Provider.of<MoneyNotifier>(context);
    CommonNotifier commonNotifier =
        Provider.of<CommonNotifier>(context, listen: false);
    AnalysisNotifier analysisNotifier = Provider.of<AnalysisNotifier>(context);
    analysisNotifier.totalMoney = moneyNotifier.debitMoney;
    analysisNotifier.knownCategoryExpense = 0;

    categoryWiseMapInit(categoryNotifier, analysisNotifier.categoryWiseMoney);
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
          if (message == null ||
              message.date!
                      .isBefore(moneyNotifier.startDate ?? DateTime.now()) &&
                  message.date!
                      .isAfter(moneyNotifier.endDate ?? DateTime.now())) {
            continue;
          }
          int amount = moneyNotifier.getMoneyFromRegex(
              moneyNotifier.moneyregex, message);
          analysisNotifier.categoryWiseMoney[categoryName?.title ?? ""] =
              analysisNotifier.categoryWiseMoney[categoryName?.title ?? ""]! +
                  amount;
          analysisNotifier.knownCategoryExpense =
              analysisNotifier.knownCategoryExpense + amount;
        }
        double percentage =
            (analysisNotifier.categoryWiseMoney[categoryName?.title ?? ""]! /
                    analysisNotifier.totalMoney) *
                100;

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

      double percentage = ((analysisNotifier.totalMoney -
                  analysisNotifier.knownCategoryExpense) /
              analysisNotifier.totalMoney) *
          100;
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
