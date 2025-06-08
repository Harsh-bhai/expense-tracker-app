import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/analysis_notifier.dart';
import '../provider/budget_notifier.dart';
import '../provider/category_notifier.dart';
import '../provider/money_notifier.dart';
import '../components/overall_budget_tile.dart';
import '../components/category_budget_expansion_tile.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((_) async {
      await Provider.of<AnalysisNotifier>(context, listen: false).calculateCategoryWiseSpending(
        categoryNotifier: Provider.of<CategoryNotifier>(context, listen: false),
        budgetNotifier: Provider.of<BudgetNotifier>(context, listen: false),
        moneyNotifier: Provider.of<MoneyNotifier>(context, listen: false),
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryNotifier = Provider.of<CategoryNotifier>(context);
    final analysisNotifier = Provider.of<AnalysisNotifier>(context);
    final budgetNotifier = Provider.of<BudgetNotifier>(context);
    

    return Scaffold(
      appBar: AppBar(title: const Text("Budget Manager")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const OverallBudgetTile(),
          const SizedBox(height: 16),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              title: const Text(
                "Category-wise Budget Limit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              children: categoryNotifier.expenseCategories.map((category) {
                final categoryTitle = category.title ?? "Unknown";
                final spent = analysisNotifier.categoryWiseMoney[categoryTitle] ?? 0;
                final limit = budgetNotifier.categoryLimits[categoryTitle] ?? 0;

                return CategoryBudgetExpansionTile(
                  title: categoryTitle,
                  icon: category.iconData,
                  color: category.bgColor ?? Colors.grey.shade400,
                  currentLimit: limit.toDouble(),
                  spent: spent.toDouble(),
                  onSet: (val) => budgetNotifier.setCategoryLimit(categoryTitle, val),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
